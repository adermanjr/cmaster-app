function submit_modal(data_item, url_item, refresh) {
    $.ajax({
      url: url_item,
      type: "POST",
      beforeSend: function(xhr){xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));},
      data: data_item,
      success: function (data, textStatus, xhr) {
        if (refresh) {
          location.reload(true);
        }
      },
      error: function (xhr, textStatus, errorThrown) {
        console.log('Error in Operation');
      }
    });
  }
  
  function excluir_item(id_item, url_item, msg){
    excluir_item_parm({id: id_item},url_item.concat("/").concat(id_item),msg);
  }
  
  function excluir_item_parm(data_item, url_item, msg){
    let confirmed = confirm(msg);
    if (confirmed) {
      $.ajax({
        url: url_item,
        type: "DELETE",
        beforeSend: function(xhr){xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));},
        data: data_item,
        success: function (data, textStatus, xhr) {
          location.reload(false);
        },
        error: function (xhr, textStatus, errorThrown) {
          console.log('Error in Operation');
        }
      }); 
    }
  }
  
  function exec_ajax_with_parms(data_item, url_item){
    $.ajax({
      url: url_item,
      type: "GET",
      beforeSend: function(xhr){xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));},
      data: data_item,
      success: function(result) {}
    });
  }