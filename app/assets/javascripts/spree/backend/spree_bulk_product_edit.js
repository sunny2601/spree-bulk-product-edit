function apply_updates() {
    window.scrollTo(0, 0);
    $('#notice').html('<div class="alert alert-info">Please wait.</div>');

    var source = new EventSource('update_products');
    source.addEventListener('update', function(e){
        response = JSON.parse(e.data);
        if (response.status == 'Products updated') {
            $('#notice').html('<div class="alert alert-success">The selected products have been updated.</div>');
        } else {
            $('#notice').html('<div class="alert alert-warning">An error occurred.</div>');
        }
        source.close();
        $('#btn-apply-updates').blur();
    });
}

$(function(){
    $('#btn-apply-updates').click(function(event){
        event.preventDefault();
        apply_updates();
    });
});
