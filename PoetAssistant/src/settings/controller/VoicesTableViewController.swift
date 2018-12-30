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

protocol VoiceListDelegate {
	func voiceSelected(voice: AVSpeechSynthesisVoice)
}
class VoicesTableViewController: UITableViewController, VoiceTableViewCellDelegate {
	private let speechSynthesizer = AVSpeechSynthesizer()

	var voiceListDelegate: VoiceListDelegate?
	
	private let voices = VoiceList.getVoiceList()
	private var selectedVoiceIdentifier: String?
	
	private class func getLanguageCode(identifier: String) -> String {
		let nsLocale = NSLocale.autoupdatingCurrent
		return nsLocale.localizedString(forLanguageCode: identifier) ?? identifier
	}
	override func viewDidLoad() {
		selectedVoiceIdentifier = Settings.getVoiceIdentifier()
		super.viewDidLoad()
		tableView.reloadData()
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return voices.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return voices[section].voices.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return voices[section].displayLanguage
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "VoiceCell", for: indexPath)
		if let voiceCell = cell as? VoiceTableViewCell {
			let voice = voices[indexPath.section].voices[indexPath.row]
			voiceCell.labelVoiceName.text = voice.name
			let qualityStringKey = voice.quality == .enhanced ? "voice_quality_enhanced" : "voice_quality_default"
			let qualityString = NSLocalizedString(qualityStringKey, comment: "")
			voiceCell.labelVoiceQuality.text = qualityString
			let isSelectedVoice = voice.identifier == selectedVoiceIdentifier
			voiceCell.imageCheck.isHidden = !isSelectedVoice
			voiceCell.labelVoiceName.bold = isSelectedVoice
			voiceCell.labelVoiceQuality.bold = isSelectedVoice
			voiceCell.delegate = self
		}
		return cell
		
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let voice = voices[indexPath.section].voices[indexPath.row]
		voiceListDelegate?.voiceSelected(voice: voice)
	}
	
	func didClickPlayButton(sender: UITableViewCell) {
		if !speechSynthesizer.isSpeaking, let indexPath = tableView.indexPath(for: sender) {
			let voice = voices[indexPath.section].voices[indexPath.row]
			speechSynthesizer.speak(Tts.createUtterance(text: NSLocalizedString("voice_preview", comment: ""), voiceIdentifier: voice.identifier))
		}
	}
}
