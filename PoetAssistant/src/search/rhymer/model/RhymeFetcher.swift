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

import CoreData


//
// Probably inefficient way to combine multiple FetchedResultsController into a single class with almost the
// same api as FetchedResultsController.
// This only aggregates NSFetchedResultsControllers which each have one section.
//
class RhymeFetcher {
	private(set) var sectionCount = 0
	private var fetchedResultsControllers = [NSFetchedResultsController<NSDictionary>]()
	private var rhymeTypes = [RhymeType]()
	internal var favorites = [String]()
	private var variants = [Int?]()
		
	func add(rhymeType:RhymeType, variant:Int?, fetchedResultsController: NSFetchedResultsController<NSDictionary>) {
		rhymeTypes.append(rhymeType)
		variants.append(variant)
		fetchedResultsControllers.append(fetchedResultsController)
	}
	
	func rhyme(at: IndexPath) -> RhymeEntry? {
		let indexPath = IndexPath(row: at.row, section: 0)
		let value = fetchedResultsControllers[at.section].object(at: indexPath)
		if let word = value[#keyPath(WordVariants.word)] as? String {
			return RhymeEntry(word: word, isFavorite: favorites.contains(word))
		} else {
			return nil
		}
	}
	
	func performFetch() throws {
		for (index, fetchedResultsController) in fetchedResultsControllers.enumerated().reversed() {
			do {
				try fetchedResultsController.performFetch()
				if let sections = fetchedResultsController.sections, sections.count > 0, sections[0].numberOfObjects > 0 {
					sectionCount += sections.count
				} else {
					fetchedResultsControllers.remove(at:index)
					rhymeTypes.remove(at:index)
					variants.remove(at:index)
				}
			} catch let error {
				throw error
			}
		}
	}
	func numberOfRowsInSection(section: Int) -> Int {
		return fetchedResultsControllers[section].sections?[0].numberOfObjects ?? 0
	}
	func rhymeType(section: Int) -> RhymeType? {
		return rhymeTypes[section]
	}
	func variant(section: Int) -> Int?{
		return variants[section]
	}
	func toText(query: String) -> String {
		var result = String(format: NSLocalizedString("share_rhymes_title", comment: ""), query)
		for section in 0..<sectionCount {
			if let rhymeType = rhymeType(section:section) {
				var subtitle: String
				if let variantNumber = variant(section: section) {
					subtitle = String(format: NSLocalizedString(rhymeType.localizedStringIdForVariant, comment: ""), query, String(variantNumber))
				} else {
					subtitle = NSLocalizedString(rhymeType.localizedStringId, comment: "")
				}
				result.append(String(format: NSLocalizedString("share_rhymes_subtitle", comment: ""), subtitle))
				for row in 0..<numberOfRowsInSection(section: section) {
					if let word = rhyme(at: IndexPath(row:row, section:section))?.word {
						result.append(String(format: NSLocalizedString("share_rhymes_word", comment: ""), word))
					}
				}
			}
		}
		return result
	}
}
struct RhymeEntry {
	let word: String
	let isFavorite: Bool
}
enum RhymeType {
	case strict
	case last_three_syllables
	case last_two_syllables
	case last_syllable
	
	var localizedStringId: String {
		switch (self) {
		case .strict: return "rhyme_match_type_0"
		case .last_three_syllables: return "rhyme_match_type_3"
		case .last_two_syllables: return "rhyme_match_type_2"
		case .last_syllable: return "rhyme_match_type_1"
		}
	}
	var localizedStringIdForVariant: String {
		switch (self) {
		case .strict: return "rhyme_variant_match_type_0"
		case .last_three_syllables: return "rhyme_variant_match_type_3"
		case .last_two_syllables: return "rhyme_variant_match_type_2"
		case .last_syllable: return "rhyme_variant_match_type_1"
		}
	}
}
