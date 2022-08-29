
$(document).ready(function(){
  $(":input").inputmask();
});
  
  
  
  /*
  
  
  console.log(data);
          console.log(textStatus);
          console.log(xhr);
          console.log("sucessou");
          $('#preparo_'.concat(id_item)).remove();
  
  
  $(document).ready(function(){
    $('.link_delete___').click(function(){
  
      let confirmed = confirm($('#delete').attr("data-msg"));
      
      if (confirmed) {
        let id_item = $('#delete').attr("data-id");
        let url_item = $('#delete').attr("data-url");
  
        $.ajax({
          url: url_item,
          type: "DELETE",
          beforeSend: function(xhr){xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));},
          data: {
            id: id_item
          },
          success: function (data, textStatus, xhr) {
            console.log(data);
          },
          error: function (xhr, textStatus, errorThrown) {
            console.log('Error in Operation');
          }
        }); 
        //event.preventDefault();
      }
                
    });
  
  });
       
  
  
  $(document).ready(function(){
  
    $('.link_modal_________').click(function(){
  
      var url_item = $('.link_modal').attr("data-url");
      var identification = $('.link_modal').attr("data-identification");
      console.log(url_item, identification);
  
      $.ajax({
        url: url_item,
        type: "GET",
        data: identification,
        success: function(result) {}
      });           
    });
  
  });
  
  
  */
  