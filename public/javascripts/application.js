// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

init_state=function() {
 return {human:"",computer:"", available:{1:1,2:2,3:3,4:4,5:5,6:6,7:7,8:8,9:9}} 
}

var state=init_state()

int_incr_element=function(elem,val){
   $(elem).val(parseInt(val) + 1)
}

$(document).ready(function() {
    $('#hasJs').show();
    $('#noscript').hide();
    $.each(['ties','computer','human'],
         function(index, value) { 
            $('#'+value).attr('value',0)
    });  
    $('#turn').attr('value','human')
    $("a").click(function() { 
         gameOver=state.available.hasOwnProperty('0')  
         id=$(this).attr('id') 
         cid=id == 'play' ? 'play' : parseInt(id)   
         available=state.available.hasOwnProperty(cid)  
         if(!gameOver && !available) {
            alert("Sorry. Move invalid. Must choose empty square.")
         }
         if ((gameOver && cid=='play') || (!gameOver && available)) {
            $('#cid').attr('value',cid)
            $('form').submit()            
         }
       });
})