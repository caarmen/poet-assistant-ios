//
//  WordVariants.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 04/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import CoreData

class WordVariants: NSManagedObject {
	
	static let COLUMN_WORD = "word"
	static let COLUMN_VARIANT_NUMBER = "variant_number"
	static let COLUMN_STRESS_SYLLABLES = "stress_syllables"
	static let COLUMN_LAST_SYLLABLE = "last_syllable"
	static let COLUMN_LAST_TWO_SYLLABLES = "last_two_syllables"
	static let COLUMN_LAST_THREE_SYLLABLES = "last_three_syllables"
	static let COLUMN_HAS_DEFINITION = "has_definition"
	
	class func createRhymesFetchResultsController(context: NSManagedObjectContext, queryText: String) -> RhymerFetchedResultsControllerWrapper {
		let result = RhymerFetchedResultsControllerWrapper()
		let request: NSFetchRequest<WordVariants> = WordVariants.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: COLUMN_VARIANT_NUMBER, ascending: true)]
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(COLUMN_WORD) ==[c] %@", queryText)
		}
		if let wordVariants = try? request.execute() {
			for (index, wordVariant) in wordVariants.enumerated() {
				let variantPrefix = (wordVariants.count > 1) ? "\(index + 1)." : ""
				if let stress_syllables = wordVariant.stress_syllables {
					result.add(sectionTitle: "\(variantPrefix)0", fetchedResultsController: createFetchResultsControllerForRhymeType(context: context, queryWord: queryText, rhymeTypeColumn: COLUMN_STRESS_SYLLABLES, rhymeValue: stress_syllables))
				}
				if let last_three_syllables = wordVariant.last_three_syllables {
					result.add(sectionTitle: "\(variantPrefix)3", fetchedResultsController: createFetchResultsControllerForRhymeType(context: context, queryWord: queryText, rhymeTypeColumn: COLUMN_LAST_THREE_SYLLABLES, rhymeValue: last_three_syllables))
				}
				if let last_two_syllables = wordVariant.last_two_syllables {
					result.add(sectionTitle: "\(variantPrefix)2", fetchedResultsController: createFetchResultsControllerForRhymeType(context: context, queryWord: queryText, rhymeTypeColumn: COLUMN_LAST_TWO_SYLLABLES, rhymeValue: last_two_syllables))
				}
				if let last_syllable = wordVariant.last_syllable {
					result.add(sectionTitle: "\(variantPrefix)1", fetchedResultsController: createFetchResultsControllerForRhymeType(context: context, queryWord: queryText, rhymeTypeColumn: COLUMN_LAST_SYLLABLE, rhymeValue: last_syllable))
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
		request.propertiesToFetch = [COLUMN_WORD]
		request.resultType = .dictionaryResultType
		request.returnsDistinctResults = true
		request.sortDescriptors = [NSSortDescriptor(key: COLUMN_WORD, ascending: true)]
		request.predicate = NSPredicate(format: "\(rhymeTypeColumn) == %@ AND \(COLUMN_WORD) !=[c] %@ AND \(COLUMN_HAS_DEFINITION) = 1", rhymeValue, queryWord)
		return NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil)
	}
	
}
