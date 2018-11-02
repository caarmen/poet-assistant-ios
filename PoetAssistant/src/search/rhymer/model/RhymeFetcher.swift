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
}
