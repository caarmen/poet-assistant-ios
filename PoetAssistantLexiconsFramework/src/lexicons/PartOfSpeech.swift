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

import Foundation

public enum PartOfSpeech : CaseIterable {
	case noun
	case verb
	case adjective
	case adverb
	
	public func localizedSectionLabel() -> String {
		var stringId: String
		switch (self) {
		case .noun: stringId = "part_of_speech_n"
		case .verb: stringId = "part_of_speech_v"
		case .adverb: stringId = "part_of_speech_r"
		case .adjective: stringId = "part_of_speech_a"
		}
		return Localization.localize(stringId: stringId)
	}
	public func localizedAbbreviation() -> String {
		var stringId: String
		switch (self) {
		case .noun: stringId = "part_of_speech_n_abbr"
		case .verb: stringId = "part_of_speech_v_abbr"
		case .adverb: stringId = "part_of_speech_r_abbr"
		case .adjective: stringId = "part_of_speech_a_abbr"
		}
		return Localization.localize(stringId: stringId)
	}
}
