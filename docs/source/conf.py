# Configuration file for the Sphinx documentation builder.

# -- Project information

project = 'Linaro Solutions Hub'
copyright = '2024 Linaro'
author = 'Philip Colmer'

release = '0.1'
version = '0.1.0'

# -- General configuration

extensions = [
    'sphinx.ext.duration',
    'sphinx.ext.doctest',
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    'sphinx.ext.intersphinx',
]

intersphinx_mapping = {
    'python': ('https://docs.python.org/3/', None),
    'sphinx': ('https://www.sphinx-doc.org/en/master/', None),
}
intersphinx_disabled_domains = ['std']

# -- Options for HTML output

# html_theme_path = ['_templates']
html_theme = 'sphinx_rtd_theme'
# html_file_suffix = ".tsx"

# html_image_dir = "images"
# html_image_path = "/images"

# html_base_url = "/library/solutions_hub"
# html_use_index = False
# html_copy_source = False
# html_domain_indices = False

# -- Options for EPUB output
epub_show_urls = 'footnote'
