var counter = 0;
var limit = 100;
function addInput(divName){
          var newdiv = document.createElement('div');
          newdiv.innerHTML =  " <br><input type='text' name='names[]'>"+
	"<input name='users["+counter+"]' type='hidden' value=1 />"+
	"<input id='users' name='users["+counter+"]' type='checkbox' value=0 />"+
	"Преподаватель";
          document.getElementById(divName).appendChild(newdiv);
          counter++;
    
}