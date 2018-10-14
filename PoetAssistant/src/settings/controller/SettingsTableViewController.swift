/**
Copyright (c) 2018 Carmen Alvarez

This file is part of Poet Assistant.

Poet Assistant is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Poet Assistant is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Poet Assistant.  If not, see <http://www.gnu.org/licenses/>.
*/

import UIKit
import AVFoundation

class SettingsTableViewController: UITableViewController, VoiceListDelegate {
	
	private let speechSynthesizer = AVSpeechSynthesizer()

	@IBOutlet weak var selectedVoice: UILabel!
	@IBOutlet weak var sliderVoiceSpeed: UISlider!
	@IBOutlet weak var sliderVoicePitch: UISlider!
	@IBOutlet weak var switchSearchHistory: UISwitch!
	

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		switchSearchHistory.isOn = Settings.isSearchHistoryEnabled()
		sliderVoiceSpeed.minimumValue = Settings.MIN_VOICE_SPEED
		sliderVoiceSpeed.maximumValue = Settings.MAX_VOICE_SPEED
		sliderVoiceSpeed.value = Settings.getVoiceSpeed()
		sliderVoicePitch.minimumValue = Settings.MIN_VOICE_PITCH
		sliderVoicePitch.maximumValue = Settings.MAX_VOICE_PITCH
		sliderVoicePitch.value = Settings.getVoicePitch()
		updateVoiceSelection()
	}

	@IBAction func didSlideVoiceSpeed(_ sender: UISlider) {
		Settings.setVoiceSpeed(speed: sender.value)
	}
	@IBAction func didSlideVoicePitch(_ sender: UISlider) {
		Settings.setVoicePitch(pitch: sender.value)
	}
	@IBAction func didClickPreview(_ sender: UIButton) {
		let utterance = Tts.createUtterance(text: NSLocalizedString("voice_preview", comment: ""))
		speechSynthesizer.speak(utterance)
	}
	@IBAction func didClickSearchHistory(_ sender: UISwitch) {
		Settings.setSearchHistoryEnabled(enabled: sender.isOn)
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "VoiceSelection" {
			if let voiceListVC = segue.destination as? VoicesTableViewController {
				voiceListVC.voiceListDelegate = self
			}
		}
	}
	func voiceSelected(voice: AVSpeechSynthesisVoice) {
		Settings.setVoiceIdentifier(identifier: voice.identifier)
		updateVoiceSelection()
		navigationController?.popViewController(animated: true)
	}
	private func updateVoiceSelection() {
		selectedVoice.text = NSLocalizedString("voice_default", comment: "")
		if let voiceIdentifier = Settings.getVoiceIdentifier() {
			if let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
				selectedVoice.text = voice.name
			}
		}
	}
}
