function createSkillUpSymbols() {
  var symbolCount = Math.floor(Math.random() * (6 - 3 + 1)) + 10;
  for (var i = 0; i < symbolCount; i++) {
    var symbol = document.createElement('span');
    symbol.className = 'skillUpSymbol';
    symbol.innerText = '+';

    var container = document.getElementById('skillUP');
    container.appendChild(symbol);

    var xPos = Math.random() * window.innerWidth;
    var yPos = Math.random() * window.innerHeight;
    symbol.style.left = xPos + 'px';
    symbol.style.top = yPos + 'px';

    setTimeout(function() {
      symbol.remove();
    }, 2000);
  }
}

window.addEventListener('message',  function(event) {
	var data = event.data;
	if (data.id == 'skillUP') {
		if (data.event == 'create') {
			createSkillUpSymbols();
		}
	}
});