#!/usr/bin/env bash
#
# Seed fictitious organisations, users, groups, seats and a subscription in
# SPIRE so that Solutions Hub documentation screenshots contain no real data.
#
# Usage:
#   SPIRE_TOKEN=<super-admin biscuit> DOCS_PERSONA_EMAIL=<inbox you control> \
#     tools/seed-docs-data.sh <command>
#
# Commands:
#   seed-base              Create orgs, users (including the persona), groups,
#                          the product subscription, and their seats.
#   seed-persona           Give the docs persona its admin and PAT seats.
#   seed-service-accounts  Create example service accounts (temporarily gives
#                          the caller an Organization Admin seat in Org A).
#   status                 Show what exists.
#   cleanup                Remove everything this script created.
#
# Environment:
#   SPIRE_TOKEN         Required. A SPIRE super-admin biscuit (not PAT-derived).
#   DOCS_PERSONA_EMAIL  Required for seed-base / seed-persona.
#   SPIRE_API_URL       Default: https://staging-spire-api.linaro.com/rest/v1
#   DOCS_SOLUTION_ID    Default: code_signing (uses the generic subscription nav)
#   DOCS_PLAN_ID        Optional: overrides the plan lookup for the subscription.
#
# All email addresses use the reserved .example TLD, so nothing is ever
# delivered. Creating users in SPIRE does not send email or touch Auth0.

set -euo pipefail

SPIRE_API_URL="${SPIRE_API_URL:-https://staging-spire-api.linaro.com/rest/v1}"
DOCS_SOLUTION_ID="${DOCS_SOLUTION_ID:-code_signing}"
STATE_FILE="$(dirname "$0")/.seed-state.json"

ORG_A="Northwind Robotics"
ORG_A_DOMAIN="northwind-robotics.example"
ORG_B="Bluefin Devices"
ORG_B_DOMAIN="bluefin-devices.example"
PRODUCT_SUB="Northwind Evaluation"
PERSONA_FIRST="Alex"
PERSONA_SURNAME="Morgan"

# first|surname|org(A/B)
USERS=(
  "Priya|Shah|A"
  "Jordan|Lee|A"
  "Marcus|Okafor|A"
  "Elena|Petrova|A"
  "Sam|Whitfield|A"
  "Hannah|Berg|A"
  "Liam|Connolly|A"
  "Grace|Tanaka|A"
  "Noah|Fischer|B"
  "Isla|Mackenzie|B"
)

# ---------------------------------------------------------------------------
# helpers

die() { echo "ERROR: $*" >&2; exit 1; }
log() { echo "==> $*" >&2; }
warn() { echo "    warning: $*" >&2; }

require_token() {
  [[ -n "${SPIRE_TOKEN:-}" ]] || die "SPIRE_TOKEN is not set"
}

require_persona() {
  [[ -n "${DOCS_PERSONA_EMAIL:-}" ]] || die "DOCS_PERSONA_EMAIL is not set"
}

# api_ok METHOD PATH [JSON_BODY] [ALLOWED_STATUSES]
# Prints the response body on stdout and sets global HTTP_STATUS (when not
# called in a subshell). Fails unless the status is 2xx or in ALLOWED_STATUSES.
HTTP_STATUS=""
BODY_FILE="$(mktemp)"
trap 'rm -f "$BODY_FILE"' EXIT
api_ok() {
  local method="$1" path="$2" body="${3:-}" allowed="${4:-}"
  local args=(-sS -X "$method" -o "$BODY_FILE" -w '%{http_code}'
    -H "Authorization: Bearer ${SPIRE_TOKEN}"
    -H "Content-Type: application/json"
    -H "Accept: application/json")
  [[ -n "$body" ]] && args+=(--data "$body")
  sleep 0.15 # stay well under the per-route throttle
  HTTP_STATUS="$(curl "${args[@]}" "${SPIRE_API_URL}${path}")"
  if [[ "$HTTP_STATUS" =~ ^2 ]] || [[ " $allowed " == *" $HTTP_STATUS "* ]]; then
    cat "$BODY_FILE"
    return 0
  fi
  echo "$method $path -> HTTP $HTTP_STATUS" >&2
  jq . "$BODY_FILE" >&2 2>/dev/null || cat "$BODY_FILE" >&2
  return 1
}

urlencode() { jq -rn --arg v "$1" '$v|@uri'; }

email_for() { # first surname orgkey
  local domain="$ORG_A_DOMAIN"
  [[ "$3" == "B" ]] && domain="$ORG_B_DOMAIN"
  echo "$(tr '[:upper:]' '[:lower:]' <<<"$1.$2")@${domain}"
}

state_get() { [[ -f "$STATE_FILE" ]] && jq -r --arg k "$1" '.[$k] // empty' "$STATE_FILE" || true; }
state_set() {
  local tmp; tmp="$(mktemp)"
  [[ -f "$STATE_FILE" ]] || echo '{}' >"$STATE_FILE"
  jq --arg k "$1" --arg v "$2" '.[$k]=$v' "$STATE_FILE" >"$tmp" && mv "$tmp" "$STATE_FILE"
}

# ---------------------------------------------------------------------------
# lookups / idempotent creators

find_org() { # name -> id
  api_ok GET "/orgs?search=$(urlencode "$1")&limit=50" |
    jq -r --arg n "$1" '(.data // [])[] | select(.name == $n) | .id' | head -1
}

ensure_org() { # name -> id
  local id resp
  id="$(find_org "$1")"
  if [[ -z "$id" ]]; then
    log "Creating org '$1'"
    resp="$(api_ok POST /org "$(jq -cn --arg n "$1" '{name:$n}')")"
    id="$(jq -r '.data.id' <<<"$resp")"
  else
    log "Org '$1' exists ($id)"
  fi
  echo "$id"
}

find_user() { # email -> id
  api_ok GET "/users?search=$(urlencode "$1")&limit=10" |
    jq -r --arg e "$1" '(.data // [])[] | select((.email_address|ascii_downcase) == ($e|ascii_downcase)) | .id' | head -1
}

ensure_user() { # first surname email org_id user_type -> id
  local id resp body
  id="$(find_user "$3")"
  if [[ -z "$id" ]]; then
    log "Creating user $1 $2 <$3>"
    body="$(jq -cn --arg f "$1" --arg s "$2" --arg e "$3" --arg o "$4" --arg t "$5" \
      '{first_name:$f, surname:$s, display_name:($f+" "+$s), email_address:$e, org_id:$o, user_type:$t}')"
    resp="$(api_ok POST /user "$body")"
    id="$(jq -r '.data.id' <<<"$resp")"
  else
    log "User <$3> exists ($id)"
  fi
  echo "$id"
}

find_org_sub() { # org_id jq-filter -> sub id
  api_ok GET "/org/$1/subscriptions" |
    jq -r "(.data // [])[] | select($2) | .id" | head -1
}

org_admin_sub() { # org_id -> sub id
  find_org_sub "$1" '(.plan.solution | tostring | test("org_administration")) and (.state // "active") == "active"'
}

# Cache of seat defs per subscription, keyed by sub id.
declare -A SEAT_DEFS
seat_defs() { # sub_id -> json array
  if [[ -z "${SEAT_DEFS[$1]:-}" ]]; then
    SEAT_DEFS[$1]="$(api_ok GET "/subscription/$1/seat_defs?expand=permissions" | jq -c '.data // .')"
  fi
  echo "${SEAT_DEFS[$1]}"
}

# First resource in a subscription, e.g. the org resource of an
# Organisation Administration subscription. Empty if there is none.
declare -A SUB_RESOURCE
sub_resource() { # sub_id -> resource id
  if [[ -z "${SUB_RESOURCE[$1]+x}" ]]; then
    SUB_RESOURCE[$1]="$(api_ok GET "/subscription/$1/resources" | jq -r '(.data // .)[0].id // empty')"
  fi
  echo "${SUB_RESOURCE[$1]}"
}

# Targeted permissions for a seat, as the Hub's Assign Seat form builds them:
# permissions that may target the subscription (scope_flag bit 2) target it;
# resource-only permissions (scope_flag 1) target the subscription's resource,
# and are dropped if it has none (e.g. Code Signer on the docs subscription).
seat_permissions() { # sub_id seat_name -> json array
  local res
  res="$(sub_resource "$1")"
  jq -c --arg n "$2" --arg r "$res" '[.[] | select(.name == $n) | .permissions[]?
    | if (((.scope_flag // 2) / 2 | floor) % 2 == 1)
        then {permission_id: .id, target_resource_id: null}
      elif $r != "" then {permission_id: .id, target_resource_id: $r}
      else empty end]' <<<"$(seat_defs "$1")"
}

# assign_seat SUB_ID SEAT_NAME user|group ASSIGNEE_ID
# Creates the seat, or brings an existing seat's permissions up to date.
assign_seat() {
  local defs def_id perms body key seat_id
  defs="$(seat_defs "$1")"
  def_id="$(jq -r --arg n "$2" '.[] | select(.name == $n) | .id' <<<"$defs" | head -1)"
  [[ -n "$def_id" ]] || die "Seat definition '$2' not found on $1"
  perms="$(seat_permissions "$1" "$2")"
  key="user_id"; [[ "$3" == "group" ]] && key="group_id"
  body="$(jq -cn --arg s "$1" --arg d "$def_id" --arg k "$key" --arg a "$4" --argjson p "$perms" \
    '{subscription_id:$s, seat_def_id:$d, targeted_permissions:$p} + {($k):$a}')"
  api_ok POST /seat "$body" "409" >/dev/null
  if [[ "$HTTP_STATUS" != "409" ]]; then
    log "Assigned seat '$2' to $4"
    return 0
  fi
  seat_id="$(api_ok GET "/subscription/$1/seats?limit=100" |
    jq -r --arg d "$def_id" --arg a "$4" '(.data // [])[]
      | select(((.def.id // .seat_def.id // .seat_def_id) == $d)
               and ((.user.id // .group.id // .user_id // .group_id) == $a)) | .id' | head -1)"
  if [[ -z "$seat_id" ]]; then
    warn "seat '$2' for $4 exists but was not found; permissions not updated"
    return 0
  fi
  api_ok PUT "/seat/$seat_id/permissions" "$(jq -cn --argjson p "$perms" '{permissions:$p}')" >/dev/null
  log "Seat '$2' already held by $4; permissions updated"
}

ensure_group() { # org_admin_sub org_id name description public [member_id] -> id
  # GET /groups only shows a super admin *public* groups in orgs they don't
  # belong to, so private groups are found via the state file or a member.
  local id resp body
  id="$(state_get "group:$3")"
  [[ -n "$id" ]] || id="$(api_ok GET "/groups?org_id=$(urlencode "$2")&limit=100" |
    jq -r --arg n "$3" '(.data // [])[] | select(.name == $n) | .id' | head -1)"
  if [[ -z "$id" && -n "${6:-}" ]]; then
    id="$(api_ok GET "/user/$6/groups" "" "404" |
      jq -r --arg n "$3" '(.data // [])[] | select(.name == $n) | .id' | head -1)"
  fi
  if [[ -z "$id" ]]; then
    log "Creating group '$3'"
    body="$(jq -cn --arg s "$1" --arg n "$3" --arg d "$4" --argjson p "$5" \
      '{subscription_id:$s, name:$n, description:$d, public_visibility:$p}')"
    resp="$(api_ok POST /group "$body" "409")"
    id="$(jq -r '.data.id // empty' <<<"$resp")"
    [[ -n "$id" ]] || { warn "group '$3' exists but is not visible to this token"; echo ""; return 0; }
  else
    log "Group '$3' exists ($id)"
  fi
  state_set "group:$3" "$id"
  echo "$id"
}

add_members() { # group_id user_id...
  local gid="$1"; shift
  [[ -n "$gid" ]] || { warn "group id unknown; skipping member add (run seed-service-accounts)"; return 0; }
  api_ok POST "/group/$gid/members" "$(jq -cn '{add:$ARGS.positional}' --args "$@")" "400 409" >/dev/null ||
    warn "could not add members to $gid"
  [[ "$HTTP_STATUS" =~ ^2 ]] || warn "adding members to $gid returned HTTP $HTTP_STATUS (may already be members)"
}

set_user_state() { # user_id state
  # An inactive user returns 404, so a re-run tolerates it.
  api_ok PATCH "/user/$1" "$(jq -cn --arg s "$2" '{state:$s}')" "404" >/dev/null
  if [[ "$HTTP_STATUS" == "404" ]]; then log "$1 not patchable (already inactive?)"; else log "Set $1 state to $2"; fi
}

ensure_email_domain() { # org_id domain
  api_ok PUT "/org/$1/email_domains" "$(jq -cn --arg d "$2" '{email_domains:[$d]}')" "400 409 422" >/dev/null
  if [[ "$HTTP_STATUS" =~ ^2 ]]; then
    log "Email domain $2 set on $1"
  else
    warn "email domain $2 rejected (HTTP $HTTP_STATUS); skipping"
  fi
}

resolve_plan() {
  if [[ -n "${DOCS_PLAN_ID:-}" ]]; then echo "$DOCS_PLAN_ID"; return; fi
  local plans
  plans="$(api_ok GET "/solution/${DOCS_SOLUTION_ID}/plans" | jq -c '.data // .')"
  [[ "$(jq length <<<"$plans")" -gt 0 ]] || die "No plans for solution ${DOCS_SOLUTION_ID}; set DOCS_PLAN_ID"
  jq -r '.[0].id' <<<"$plans"
}

ensure_product_sub() { # org_id -> sub id
  local id plan resp body
  id="$(find_org_sub "$1" "(.name // .subscription_name) == \"$PRODUCT_SUB\" and .state != \"cancelled\"")"
  if [[ -z "$id" ]]; then
    plan="$(resolve_plan)"
    log "Creating subscription '$PRODUCT_SUB' on $plan"
    body="$(jq -cn --arg p "$plan" --arg o "$1" --arg n "$PRODUCT_SUB" --arg x "$(date -d '+1 year' +%F)" \
      --arg c "procurement@${ORG_A_DOMAIN}" \
      '{plan_id:$p, owner_id:$o, subscription_name:$n, expiration_date:$x, autorenewal:true, subscription_contacts:[$c]}')"
    resp="$(api_ok POST /subscription "$body")"
    id="$(jq -r '.data.id' <<<"$resp")"
  else
    log "Subscription '$PRODUCT_SUB' exists ($id)"
  fi
  api_ok PATCH "/subscription/$id" '{"state":"active"}' >/dev/null
  echo "$id"
}

# ---------------------------------------------------------------------------
# commands

cmd_seed_base() {
  require_token; require_persona
  local org_a org_b sub_a sub_b prod persona g_fw g_qa
  declare -A U

  org_a="$(ensure_org "$ORG_A")"; state_set org_a "$org_a"
  org_b="$(ensure_org "$ORG_B")"; state_set org_b "$org_b"
  sub_a="$(org_admin_sub "$org_a")"; [[ -n "$sub_a" ]] || die "No org admin subscription for $ORG_A"
  sub_b="$(org_admin_sub "$org_b")"; [[ -n "$sub_b" ]] || die "No org admin subscription for $ORG_B"
  state_set org_a_admin_sub "$sub_a"; state_set org_b_admin_sub "$sub_b"

  ensure_email_domain "$org_a" "$ORG_A_DOMAIN"
  ensure_email_domain "$org_b" "$ORG_B_DOMAIN"

  local entry first surname org email
  for entry in "${USERS[@]}"; do
    IFS='|' read -r first surname org <<<"$entry"
    email="$(email_for "$first" "$surname" "$org")"
    local oid="$org_a"; [[ "$org" == "B" ]] && oid="$org_b"
    U[$first]="$(ensure_user "$first" "$surname" "$email" "$oid" human)"
  done
  persona="$(ensure_user "$PERSONA_FIRST" "$PERSONA_SURNAME" "$DOCS_PERSONA_EMAIL" "$org_a" human)"
  state_set persona "$persona"

  # Organisation Administration seats (before any user is made inactive).
  assign_seat "$sub_a" "Organization Admin" user "${U[Priya]}"
  assign_seat "$sub_a" "Group Administrator" user "${U[Marcus]}"
  assign_seat "$sub_a" "PAT User" user "${U[Jordan]}"
  assign_seat "$sub_a" "PAT User" user "${U[Elena]}"
  assign_seat "$sub_a" "PAT User" user "${U[Sam]}"
  assign_seat "$sub_b" "Organization Admin" user "${U[Isla]}"

  g_fw="$(ensure_group "$sub_a" "$org_a" "Firmware Team" "Engineers working on device firmware" true "${U[Jordan]}")"
  g_qa="$(ensure_group "$sub_a" "$org_a" "QA Team" "Release testing and validation" false "${U[Sam]}")"
  add_members "$g_fw" "${U[Jordan]}" "${U[Elena]}" "${U[Marcus]}" "$persona"
  add_members "$g_qa" "${U[Sam]}" "${U[Hannah]}" "$persona"

  prod="$(ensure_product_sub "$org_a")"; state_set product_sub "$prod"
  assign_seat "$prod" "Subscription Administrator" user "${U[Priya]}"
  assign_seat "$prod" "Code Signer" user "${U[Jordan]}"
  assign_seat "$prod" "Code Signer" user "${U[Elena]}"
  assign_seat "$prod" "Code Signer" group "$g_fw"
  assign_seat "$prod" "GPG Reader" user "${U[Sam]}"

  # A spread of states for the user table. Hannah stays "created".
  local name
  for name in Priya Jordan Marcus Elena Sam Noah Isla; do set_user_state "${U[$name]}" active; done
  set_user_state "${U[Liam]}" unverified
  set_user_state "${U[Grace]}" inactive

  log "seed-base done. Next: sign up on Solutions Hub as $DOCS_PERSONA_EMAIL, then run seed-persona."
}

cmd_seed_persona() {
  require_token; require_persona
  local persona sub_a sub_b prod
  persona="$(find_user "$DOCS_PERSONA_EMAIL")"; [[ -n "$persona" ]] || die "Persona not found; run seed-base first"
  sub_a="$(org_admin_sub "$(find_org "$ORG_A")")"
  sub_b="$(org_admin_sub "$(find_org "$ORG_B")")"
  prod="$(find_org_sub "$(find_org "$ORG_A")" "(.name // .subscription_name) == \"$PRODUCT_SUB\" and .state == \"active\"")"
  [[ -n "$sub_a" && -n "$sub_b" && -n "$prod" ]] || die "Base data missing; run seed-base first"

  assign_seat "$sub_a" "Organization Admin" user "$persona"
  assign_seat "$sub_a" "PAT User" user "$persona"
  assign_seat "$sub_b" "Organization Admin" user "$persona"
  assign_seat "$prod" "Subscription Administrator" user "$persona"
  log "seed-persona done. Sign out and back in as the persona to pick up the new seats."
}

cmd_seed_service_accounts() {
  require_token
  local org_a sub_a me resp seat_id name
  org_a="$(find_org "$ORG_A")"; sub_a="$(org_admin_sub "$org_a")"
  [[ -n "$sub_a" ]] || die "Base data missing; run seed-base first"
  me="$(api_ok GET /user/self | jq -r '.data.id // .id')"

  log "Temporarily granting caller ($me) Organization Admin in $ORG_A"
  assign_seat "$sub_a" "Organization Admin" user "$me"
  SPIRE_TOKEN="$(api_ok GET /user/self/session | jq -r '.biscuit.token')"

  local existing
  existing="$(api_ok GET "/service_accounts?org_id=$(urlencode "$org_a")&limit=100" | jq -r '(.data // [])[].display_name')"
  for entry in "CI Build Runner|Runs nightly firmware builds" "Release Publisher|Publishes signed release artefacts"; do
    IFS='|' read -r name desc <<<"$entry"
    if grep -qxF "$name" <<<"$existing"; then
      log "Service account '$name' exists"; continue
    fi
    api_ok POST /service_account "$(jq -cn --arg o "$org_a" --arg n "$name" --arg d "$desc" \
      '{org_id:$o, display_name:$n, description:$d}')" >/dev/null
    log "Created service account '$name'"
  done

  seat_id="$(api_ok GET "/user/$me/seats" |
    jq -r --arg s "$sub_a" '(.data // [])[] | select(.subscription.id == $s and .def.name == "Organization Admin") | .id' | head -1)"
  if [[ -n "$seat_id" ]]; then
    api_ok DELETE "/seat/$seat_id" >/dev/null && log "Removed temporary seat $seat_id"
  else
    warn "could not find the temporary seat; remove it manually"
  fi
}

cmd_status() {
  require_token
  local org
  for org in "$ORG_A" "$ORG_B"; do
    local id; id="$(find_org "$org")"
    echo "## $org ${id:-(missing)}"
    [[ -n "$id" ]] || continue
    api_ok GET "/org/$id/subscriptions" | jq -r '(.data // [])[] | "  sub  \(.id)  \(.name // .subscription_name)  [\(.state)]"'
    api_ok GET "/users?org_id=$(urlencode "$id")&limit=100" | jq -r '(.data // [])[] | "  user \(.id)  \(.display_name)  <\(.email_address)>  [\(.state // "?")]"'
    api_ok GET "/groups?org_id=$(urlencode "$id")&limit=100" | jq -r '(.data // [])[] | "  group \(.id)  \(.name)"'
  done
}

cmd_cleanup() {
  require_token
  read -r -p "Remove all docs seed data from ${SPIRE_API_URL}? [y/N] " ok
  [[ "$ok" == "y" ]] || exit 0
  local org id
  for org in "$ORG_A" "$ORG_B"; do
    id="$(find_org "$org")"; [[ -n "$id" ]] || continue
    log "Cleaning $org ($id)"
    api_ok GET "/groups?org_id=$(urlencode "$id")&limit=100" | jq -r '(.data // [])[].id' |
      while read -r g; do api_ok DELETE "/group/$g" "404" >/dev/null && log "Deleted group $g"; done
    api_ok GET "/service_accounts?org_id=$(urlencode "$id")&limit=100" "" "403 404" | jq -r '(.data // [])[].id' |
      while read -r s; do api_ok DELETE "/service_account/$s" "403 404" >/dev/null || true; done
    api_ok GET "/org/$id/subscriptions" | jq -r '(.data // [])[] | select(.plan.solution|tostring|test("org_administration")|not) | .id' |
      while read -r s; do api_ok PATCH "/subscription/$s" '{"state":"cancelled"}' >/dev/null && log "Cancelled $s"; done
    api_ok GET "/users?org_id=$(urlencode "$id")&limit=100" | jq -r '(.data // [])[].id' |
      while read -r u; do api_ok DELETE "/user/$u" "404" >/dev/null && log "Deleted user $u"; done
    api_ok DELETE "/org/$id" >/dev/null && log "Deleted org $id"
  done
  rm -f "$STATE_FILE"
}

case "${1:-}" in
  seed-base) cmd_seed_base ;;
  seed-persona) cmd_seed_persona ;;
  seed-service-accounts) cmd_seed_service_accounts ;;
  status) cmd_status ;;
  cleanup) cmd_cleanup ;;
  *) sed -n '2,30p' "$0"; exit 1 ;;
esac
