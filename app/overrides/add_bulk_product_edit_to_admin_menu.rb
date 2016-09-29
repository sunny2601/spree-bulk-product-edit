Deface::Override.new(
    :original => 'c782fadd3d631a2b4057029ff0a67bf9b9f9df80',
    :virtual_path => 'spree/layouts/admin',
    :name => 'add_bulk_product_edit_to_admin_menu',
    :insert_bottom => '[data-hook="admin_tabs"]',
    :text => '<ul class="nav nav-sidebar">
        <%= tab Spree.t(:bulk_product_edit), :url => admin_bulk_product_edits_url, :icon => \'list-alt\' %>
      </ul>'
)
