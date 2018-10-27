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

import XCTest

class TtsSettingsTest: XCTestCase {

	var app: XCUIApplication!
	override func setUp() {
		continueAfterFailure = false
		app = UITestUtils.launchApp()
		UITestUtils.openSettings(app: app)
	}

    override func tearDown() {
    }

	func testVoiceSelection() {
		let voiceCell = app.tables.cells.matching(identifier: "SettingVoice").firstMatch
		voiceCell.tap()
		for _ in 0...3 {
			app.swipeUp()
		}
		let voicesCount = app.tables.cells.count
		let lastVoice = app.tables.cells.element(boundBy: voicesCount - 1)
		let lastVoicePreview = lastVoice.buttons.firstMatch
		playPreview(playButton: lastVoicePreview)
		lastVoice.tap()
		let previewButton = getVoicePreviewButton()
		playPreview(playButton: previewButton)
	}
    func testVoiceSpeed() {
		let voiceSpeedSlider = getSlider(cellIdentifier: "SettingVoiceSpeed")
		let voicePreviewButton = getVoicePreviewButton()
		let previewDurationNormalSpeed = timePreview(withVoiceSpeed: 0.5, voiceSpeedSlider: voiceSpeedSlider, playButton: voicePreviewButton)
		let previewDurationFast = timePreview(withVoiceSpeed: 1.0, voiceSpeedSlider: voiceSpeedSlider, playButton: voicePreviewButton)
		let previewDurationSlow = timePreview(withVoiceSpeed: 0.0, voiceSpeedSlider: voiceSpeedSlider, playButton: voicePreviewButton)
		XCTAssertGreaterThan(previewDurationSlow, previewDurationNormalSpeed)
		XCTAssertGreaterThan(previewDurationNormalSpeed, previewDurationFast)
    }
	
	
	func testVoicePitch() {
		let voicePitchSlider = getSlider(cellIdentifier: "SettingVoicePitch")
		let voicePreviewButton = getVoicePreviewButton()
		playPreview(playButton: voicePreviewButton)
		dragSlider(slider: voicePitchSlider, toPosition: 0.95)
		playPreview(playButton: voicePreviewButton)
		dragSlider(slider: voicePitchSlider, toPosition: 0.0)
		playPreview(playButton: voicePreviewButton)
	}
	
	private func getSlider(cellIdentifier: String) -> XCUIElement {
		let cell = app.tables.cells.matching(identifier: cellIdentifier).firstMatch
		return cell.sliders.firstMatch
	}
	private func timePreview(withVoiceSpeed: Double, voiceSpeedSlider: XCUIElement, playButton: XCUIElement) -> TimeInterval {
		let beforeTimestamp = NSDate().timeIntervalSince1970
		dragSlider(slider: voiceSpeedSlider, toPosition: withVoiceSpeed)
		playPreview(playButton: playButton)
		let afterTimestamp = NSDate().timeIntervalSince1970
		return afterTimestamp - beforeTimestamp
	}
	
	private func playPreview(playButton: XCUIElement) {
		playButton.tap()
		UITestUtils.wait(test:self, timeout: 1)
		UITestUtils.waitForPlayButtonToHavePlayImage(test: self, playButton: playButton, timeout: 15)
	}

	// https://stackoverflow.com/questions/46785790/ui-testing-slider-fails-to-adjust-when-nested-in-table-view-cell
	private func dragSlider(slider: XCUIElement, toPosition: Double) {
		//slider.adjust(toNormalizedSliderPosition: toPosition) // causes a crash
		let currentPercent = (slider.value as! NSString).doubleValue / 100.0
		let currentPosition = slider.coordinate(withNormalizedOffset: CGVector(dx: currentPercent, dy: 0.5))
		let targetPosition = slider.coordinate(withNormalizedOffset: CGVector(dx: toPosition, dy: 0.5))
		currentPosition.press(forDuration: 0.1, thenDragTo: targetPosition)
	}
	private func getVoicePreviewButton() -> XCUIElement {
		let voicePreviewCell = app.tables.cells.matching(identifier: "SettingVoicePreview").firstMatch
		return voicePreviewCell.buttons.firstMatch
	}
}
