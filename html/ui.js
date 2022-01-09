$('document').ready(function(){
	let audio = null

	function playAudio(audioSrc){
		if (audio!=null){
			audio.stop()
		}
		audio = new Howl({src:[audioSrc]})
		audio.volume(0.3)
		audio.play()
	}

	function intro() {
		$('img').attr("src", "./gif/hack_intro.gif")
		playAudio('./audio/intro.mp3')
		setTimeout(function() {
			$('img').attr('src', "")
			audio.stop()
		}, 3500)
	}
	
	function success() {
		$('img').attr("src", "./gif/hack_success.gif")
		playAudio('./audio/hack_success.mp3')
		setTimeout(function() {
			$('img').attr('src', "")
		}, 3000)
	}
	
	function fail() {
		$('img').attr("src", "./gif/hack_fail.gif")
		playAudio('./audio/hack_fail.mp3')
		setTimeout(function() {
			$('img').attr('src', "")
		}, 3000)
	}
  
  
	window.addEventListener("message", (event) => {
		let type = event.data.type
		if (type == "intro"){
			intro()
		} 
		
		else if (type == "success"){
			success()
		}
		
		else if (type == "fail"){
			fail()
		}

		else if (type == "audio") {
			if (event.data.audioType == "keypress"){
				playAudio("./audio/keypress.mp3")
			}
			else if (event.data.audioType == "correct"){
				playAudio("./audio/correct.mp3")
			}
			else if (event.data.audioType == "incorrect"){
				playAudio("./audio/incorrect.mp3")
			}
			else if (event.data.audioType == "fake"){
				playAudio("./audio/fake_pattern.mp3")
			}
      else if (event.data.audioType == "real"){
				playAudio("./audio/real_pattern.mp3")
			}
		}
	})
  
})
  
  