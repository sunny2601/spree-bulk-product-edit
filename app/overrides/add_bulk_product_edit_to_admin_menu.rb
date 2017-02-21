Deface::Override.new(
    original: '9128c1b242aca5889d7c052b8579f987c7897d3c',
    virtual_path: 'spree/layouts/admin',
    name: 'add_bulk_product_edit_to_admin_menu',
    insert_bottom: '[data-hook="admin_tabs"]',
    text: '<ul class="nav nav-sidebar">
        <%= tab Spree.t(:bulk_product_edit), url: admin_bulk_product_edits_url, icon: \'list-alt\' %>
      </ul>'
)
