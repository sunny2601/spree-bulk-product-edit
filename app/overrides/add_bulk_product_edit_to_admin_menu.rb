Deface::Override.new(
    :original => '1ff398339f1a03870dde177213dd042b67365c56',
    :virtual_path => 'spree/layouts/admin',
    :name => 'add_bulk_product_edit_to_admin_menu',
    :insert_bottom => '[data-hook="admin_tabs"]',
    :text => '<ul class="nav nav-sidebar">
        <%= tab Spree.t(:bulk_product_edit), :url => admin_bulk_product_edits_url, :icon => \'list-alt\' %>
      </ul>'
)
