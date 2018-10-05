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

class WordVariants: NSManagedObject {
	
	class func createRhymesFetchResultsController(context: NSManagedObjectContext, queryText: String) -> RhymerFetchedResultsControllerWrapper {
		let result = RhymerFetchedResultsControllerWrapper()
		let request: NSFetchRequest<WordVariants> = WordVariants.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: #keyPath(WordVariants.variant_number), ascending: true)]
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(#keyPath(WordVariants.word)) ==[c] %@", queryText)
		}
		if let wordVariants = try? request.execute() {
			for (index, wordVariant) in wordVariants.enumerated() {
				let variantPrefix = (wordVariants.count > 1) ? "\(index + 1)." : ""
				if let stress_syllables = wordVariant.stress_syllables {
					result.add(sectionTitle: "\(variantPrefix)0", fetchedResultsController: createFetchResultsControllerForRhymeType(context: context, queryWord: queryText, rhymeTypeColumn: #keyPath(WordVariants.stress_syllables), rhymeValue: stress_syllables))
				}
				if let last_three_syllables = wordVariant.last_three_syllables {
					result.add(sectionTitle: "\(variantPrefix)3", fetchedResultsController: createFetchResultsControllerForRhymeType(context: context, queryWord: queryText, rhymeTypeColumn: #keyPath(WordVariants.last_three_syllables), rhymeValue: last_three_syllables))
				}
				if let last_two_syllables = wordVariant.last_two_syllables {
					result.add(sectionTitle: "\(variantPrefix)2", fetchedResultsController: createFetchResultsControllerForRhymeType(context: context, queryWord: queryText, rhymeTypeColumn: #keyPath(WordVariants.last_two_syllables), rhymeValue: last_two_syllables))
				}
				if let last_syllable = wordVariant.last_syllable {
					result.add(sectionTitle: "\(variantPrefix)1", fetchedResultsController: createFetchResultsControllerForRhymeType(context: context, queryWord: queryText, rhymeTypeColumn: #keyPath(WordVariants.last_syllable), rhymeValue: last_syllable))
				}
			}
		}
		
		return result
	}
	
	private class func createFetchResultsControllerForRhymeType(
		context: NSManagedObjectContext,
		queryWord: String,
		rhymeTypeColumn: String,
		rhymeValue: String) -> NSFetchedResultsController<NSDictionary> {
		
		let request = NSFetchRequest<NSDictionary>(entityName: "WordVariants")
		request.propertiesToFetch = [#keyPath(WordVariants.word)]
		request.resultType = .dictionaryResultType
		request.returnsDistinctResults = true
		request.sortDescriptors = [NSSortDescriptor(key: #keyPath(WordVariants.word), ascending: true)]
		request.predicate = NSPredicate(format: "\(rhymeTypeColumn) == %@ AND \(#keyPath(WordVariants.word)) !=[c] %@ AND \(#keyPath(WordVariants.has_definition)) = 1", rhymeValue, queryWord)
		return NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil)
	}
	
}
