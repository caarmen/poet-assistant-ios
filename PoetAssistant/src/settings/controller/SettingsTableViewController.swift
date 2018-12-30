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

	@IBOutlet weak var selectedVoice: UILabel!
	@IBOutlet weak var sliderVoiceSpeed: UISlider!
	@IBOutlet weak var sliderVoicePitch: UISlider!
	
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var switchMatchAORAO: UISwitch!
	@IBOutlet weak var switchMatchAOAA: UISwitch!
	@IBOutlet weak var switchReverseThesaurus: UISwitch!
	
	@IBOutlet weak var switchSearchHistory: UISwitch!
	@IBOutlet weak var switchEfficientLayout: UISwitch!
	@IBOutlet weak var switchDarkTheme: UISwitch!
	private var ttsPlayButtonConnector: TtsPlayButtonConnector?
	

	override func viewDidLoad() {
		super.viewDidLoad()
		ttsPlayButtonConnector = TtsPlayButtonConnector(playButton: playButton)
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		view.backgroundColor = Settings.getTheme().backgroundColor
		switchSearchHistory.isOn = Settings.isSearchHistoryEnabled()
		sliderVoiceSpeed.minimumValue = Settings.MIN_VOICE_SPEED
		sliderVoiceSpeed.maximumValue = Settings.MAX_VOICE_SPEED
		sliderVoiceSpeed.value = Settings.getVoiceSpeed()
		sliderVoicePitch.minimumValue = Settings.MIN_VOICE_PITCH
		sliderVoicePitch.maximumValue = Settings.MAX_VOICE_PITCH
		sliderVoicePitch.value = Settings.getVoicePitch()
		switchMatchAORAO.isOn = Settings.getMatchAORAOEnabled()
		switchMatchAOAA.isOn = Settings.getMatchAOAAEnabled()
		switchReverseThesaurus.isOn = Settings.getReverseThesaurusEnabled()
		switchEfficientLayout.isOn = Settings.getEfficientLayoutEnabled()
		switchDarkTheme.isOn = Settings.getTheme().name == Theme.DARK_THEME.name
		updateVoiceSelection()
	}

	@IBAction func didSlideVoiceSpeed(_ sender: UISlider) {
		Settings.setVoiceSpeed(speed: sender.value)
	}
	@IBAction func didSlideVoicePitch(_ sender: UISlider) {
		Settings.setVoicePitch(pitch: sender.value)
	}
	@IBAction func didClickPreview(_ sender: UIButton) {
		ttsPlayButtonConnector?.textToSpeak = NSLocalizedString("voice_preview", comment: "")
		ttsPlayButtonConnector?.didTapPlayButton()
	}
	@IBAction func didClickMatchAORAO(_ sender: UISwitch) {
		Settings.setMatchAORAOEnabled(enabled: sender.isOn)
	}
	@IBAction func didClickMatchAOAA(_ sender: UISwitch) {
		Settings.setMatchAOAAEnabled(enabled: sender.isOn)
	}
	
	@IBAction func didClickReverseThesaurus(_ sender: UISwitch) {
		Settings.setReverseThesaurusEnabled(enabled: sender.isOn)
	}
	@IBAction func didClickSearchHistory(_ sender: UISwitch) {
		Settings.setSearchHistoryEnabled(enabled: sender.isOn)
	}

	@IBAction func didClickEfficientLayout(_ sender: UISwitch) {
		Settings.setEfficientLayoutEnabled(enabled: sender.isOn)
	}
	
	@IBAction func didClickDarkTheme(_ sender: UISwitch) {
		let theme = sender.isOn ? Theme.DARK_THEME : Theme.LIGHT_THEME
		Settings.setTheme(theme: theme)
		theme.apply()
		if let window = view.window {
			theme.reload(window: window)
		}
		view.backgroundColor = theme.backgroundColor
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
