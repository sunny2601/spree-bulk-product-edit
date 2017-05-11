Deface::Override.new(
    original: '9128c1b242aca5889d7c052b8579f987c7897d3c',
    virtual_path: 'spree/layouts/admin',
    name: 'add_bulk_product_edit_to_admin_menu',
    insert_bottom: '[data-hook="admin_tabs"]',
    text: "<ul class=\"nav nav-sidebar\">
          <%= main_menu_tree Spree.t(:bulk_product_edit), icon: 'list-alt', sub_menu: 'bulk_product_edit', url: '#sidebar-bulk-product-edit' %>
      </ul>",
    disabled: false
)

