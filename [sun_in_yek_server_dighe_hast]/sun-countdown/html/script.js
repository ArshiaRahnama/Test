var CD = {
	isPlay: false,
	isStop: false,
	startTime: 0,
	duration: 0,
	lastNumber: null,
	timer: null,

	anim: function (count) {
		this.isPlay = true;
		this.isStop = false;
		this.duration = count;
		this.lastNumber = count;
		this.startTime = performance.now();

		this._tickFrame();
	},

	_tickFrame: function () {
		if (this.isStop) {
			clearTimeout(this.timer);
			countdown.innerText = "stop";
			countdown.style.color = "rgb(255,55,55)";
			countdown.style.opacity = "0";
			this.isPlay = false;
			this.isStop = false;
			return;
		}

		let now = performance.now();
		let elapsed = Math.floor((now - this.startTime) / 1000);
		let remaining = this.duration - elapsed;

		if (remaining <= 0) {
			countdown.innerText = "0";
			countdown.style.color = "rgb(255,255,55)";
			countdown.style.top = "20%";
			countdown.style.opacity = "1";
			this.tick("last");
			setTimeout(() => {
				countdown.style.opacity = "0";
				countdown.style.top = "5%";
				this.isPlay = false;
			}, 1500);
			return;
		}

		if (remaining !== this.lastNumber) {
			countdown.innerText = remaining;
			countdown.style.fontSize = "2em";
			countdown.style.top = "20%";
			countdown.style.opacity = "1";
			countdown.style.color = remaining < 10 ? "rgb(255,55,255)" : "rgb(255,255,255)";
			
			if (remaining <= 10) {
				this.tick("");
			}

			setTimeout(() => {
				countdown.style.fontSize = "3em";
				countdown.style.opacity = "0";
			}, 300);

			this.lastNumber = remaining;
		}

		this.timer = setTimeout(() => this._tickFrame(), 100);
	},

	tick: function (type) {
	}
};

window.addEventListener('message', (event) => {
	let num = event.data.text.replace(/^.{3}/, '');
	if (CD.isPlay) {
		if (num == "stop") {
			CD.isStop = true;
			console.log("stop countdown");
		} else {
			console.log("the countdown is already running");
		}
	} else if (Number.isInteger(parseInt(num, 10))) {
		CD.anim(parseInt(num, 10));
	} else {
		console.log("Use a number");
	}
});
