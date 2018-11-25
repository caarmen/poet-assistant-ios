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

public class WordVariants: NSManagedObject {
	
	public class func createRhymeFetcher(context: NSManagedObjectContext, queryText: String, favorites: [String]) -> RhymeFetcher {
		let result = RhymeFetcher()
		result.favorites = favorites
		let request: NSFetchRequest<WordVariants> = WordVariants.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: #keyPath(WordVariants.variant_number), ascending: true)]
		if !queryText.isEmpty {
			request.predicate = NSPredicate(format: "\(#keyPath(WordVariants.word)) ==[c] %@", queryText)
		}
		if let wordVariants = try? request.execute() {
			let indicateVariants = (wordVariants.count > 1)

			for wordVariant in wordVariants {
				let variantNumber = indicateVariants ? Int(wordVariant.variant_number) : nil
				result.add(
					rhymeType: .strict,
					variant: variantNumber,
					fetchedResultsController: createFetchResultsControllerForRhymeType(
						context: context,
						predicate: createPredicateForStressSyllableMatch(wordVariant: wordVariant)))
				if wordVariant.last_three_syllables != nil {
					result.add(
						rhymeType: .last_three_syllables,
						variant: variantNumber,
						fetchedResultsController: createFetchResultsControllerForRhymeType(
							context: context,
							predicate: createPredicateForLastThreeSyllableMatch(wordVariant: wordVariant)!))
				}
				if wordVariant.last_two_syllables != nil {
					result.add(
						rhymeType: .last_two_syllables,
						variant: variantNumber,
						fetchedResultsController: createFetchResultsControllerForRhymeType(
							context: context,
							predicate: createPredicateForLastTwoSyllableMatch(wordVariant: wordVariant)!))
				}
				result.add(
					rhymeType: .last_syllable,
					variant: variantNumber,
					fetchedResultsController: createFetchResultsControllerForRhymeType(
						context: context,
						predicate: createPredicateForLastSyllableMatch(wordVariant: wordVariant)))
			}
		}
		
		return result
	}
	
	// Return a pattern of the given syllables which will match sound1 and sound2 interchangeably.
	// For example, if we have  syllables=AORNIY, sound1=AOR, sound2=AO, this will return (AOR|AO)NIY, which can then be used to match both AORNIY and AONIY.
	private class func createSyllableExpression(syllables: String, sounds: String...) -> String {
		var result = syllables
		sounds.forEach { sound in
			result = result.replacingOccurrences(of: sound, with: "__TEMPLATE__")
		}
		let pattern = sounds.joined(separator: "|")
		return result.replacingOccurrences(of: "__TEMPLATE__", with: "(\(pattern))")
	}
	private class func createPredicateForSyllableMatch(syllablesColumn: String,
													   syllablesValue: String) -> NSPredicate {
		let matchAORAOEnabled = false // TODO Settings.getMatchAORAOEnabled()
		let matchAOAAEnabled = false // TODO Settings.getMatchAOAAEnabled()
		var syllablesExpression = syllablesValue
		if (matchAORAOEnabled && !matchAOAAEnabled) {
			syllablesExpression = createSyllableExpression(syllables: syllablesValue, sounds: "AOR", "AO")
		} else if (!matchAORAOEnabled && matchAOAAEnabled) {
			syllablesExpression = createSyllableExpression(syllables: syllablesValue, sounds: "AO", "AA")
		} else if (matchAORAOEnabled && matchAOAAEnabled) {
			syllablesExpression = createSyllableExpression(syllables: syllablesValue, sounds: "AOR", "AO", "AA")
		}
		if syllablesExpression == syllablesValue {
			return NSPredicate(format: "\(syllablesColumn) = %@", syllablesValue)
		} else {
			return NSPredicate(format: "\(syllablesColumn) MATCHES %@", syllablesExpression)
		}
	}
	private class func createPredicateForStressSyllableMatch(wordVariant: WordVariants) -> NSPredicate {
		let matchingPredicate = createPredicateForSyllableMatch(syllablesColumn: #keyPath(WordVariants.stress_syllables), syllablesValue: wordVariant.stress_syllables!)
		let excludingPredicate = createPredicateExcludingSameWord(wordVariant: wordVariant)
		return concatenatePredicates(subpredicates: [matchingPredicate, excludingPredicate])
	}
	
	private class func createPredicateForLastThreeSyllableMatch(wordVariant: WordVariants) -> NSPredicate? {
		if wordVariant.last_three_syllables == nil {
			return nil
		}
		let matchingPredicate = createPredicateForSyllableMatch(syllablesColumn: #keyPath(WordVariants.last_three_syllables), syllablesValue: wordVariant.last_three_syllables!)
		let excludeSameWordPredicate = createPredicateExcludingSameWord(wordVariant: wordVariant)
		let excludeStressSyllablesPredicate = createPredicateExcludingStressSyllables(wordVariant: wordVariant)
		return concatenatePredicates(subpredicates: [matchingPredicate, excludeSameWordPredicate, excludeStressSyllablesPredicate])
	}
	
	private class func createPredicateForLastTwoSyllableMatch(wordVariant: WordVariants) -> NSPredicate? {
		if wordVariant.last_two_syllables == nil {
			return nil
		}
		let matchingPredicate = createPredicateForSyllableMatch(syllablesColumn: #keyPath(WordVariants.last_two_syllables), syllablesValue: wordVariant.last_two_syllables!)
		let excludeSameWordPredicate = createPredicateExcludingSameWord(wordVariant: wordVariant)
		let excludeStressSyllablesPredicate = createPredicateExcludingStressSyllables(wordVariant: wordVariant)
		let excludeLastThreeSyllablesPredicate = createPredicateExcludingLastThreeSyllables(wordVariant: wordVariant)
		return concatenatePredicates(subpredicates: [matchingPredicate, excludeSameWordPredicate, excludeStressSyllablesPredicate, excludeLastThreeSyllablesPredicate])
	}
	
	private class func createPredicateForLastSyllableMatch(wordVariant: WordVariants) -> NSPredicate {
		let matchingPredicate = createPredicateForSyllableMatch(syllablesColumn: #keyPath(WordVariants.last_syllable), syllablesValue: wordVariant.last_syllable!)
		let excludeSameWordPredicate = createPredicateExcludingSameWord(wordVariant: wordVariant)
		let excludeStressSyllablesPredicate = createPredicateExcludingStressSyllables(wordVariant: wordVariant)
		let excludeLastThreeSyllablesPredicate = createPredicateExcludingLastThreeSyllables(wordVariant: wordVariant)
		let excludeLastTwoSyllablesPredicate = createPredicateExcludingLastTwoSyllables(wordVariant: wordVariant)
		return  concatenatePredicates(subpredicates: [matchingPredicate, excludeSameWordPredicate, excludeStressSyllablesPredicate, excludeLastThreeSyllablesPredicate, excludeLastTwoSyllablesPredicate])
	}
	
	private class func concatenatePredicates(subpredicates: [NSPredicate?]) -> NSPredicate {
		let nonNullPredicates = subpredicates.filter { subpredicate in
			return subpredicate != nil
			} as! [NSPredicate]
		return NSCompoundPredicate(type: .and, subpredicates: nonNullPredicates)
	}
	private class func createPredicateExcludingSyllables(syllablesValue: String?, syllablesColumn: String) -> NSPredicate? {
		if syllablesValue != nil {
			return NSCompoundPredicate(
				type: .or,
				subpredicates: [NSPredicate(format: "\(syllablesColumn) = nil"),
								NSPredicate(format: "\(syllablesColumn) !=[c] %@", syllablesValue!)])
		} else {
			return nil
		}
	}
	
	private class func createPredicateExcludingSameWord(wordVariant: WordVariants) -> NSPredicate {
		return NSPredicate(format: "\(#keyPath(WordVariants.word)) !=[c] %@ AND \(#keyPath(WordVariants.has_definition)) = 1",
			wordVariant.word!) // TODO update schema to make word not optional
	}
	private class func createPredicateExcludingStressSyllables(wordVariant: WordVariants) -> NSPredicate? {
		return createPredicateExcludingSyllables(syllablesValue: wordVariant.stress_syllables, syllablesColumn: #keyPath(WordVariants.stress_syllables))
	}
	private class func createPredicateExcludingLastThreeSyllables(wordVariant: WordVariants) -> NSPredicate? {
		return createPredicateExcludingSyllables(syllablesValue: wordVariant.last_three_syllables, syllablesColumn: #keyPath(WordVariants.last_three_syllables))
	}
	private class func createPredicateExcludingLastTwoSyllables(wordVariant: WordVariants) -> NSPredicate? {
		return createPredicateExcludingSyllables(syllablesValue: wordVariant.last_two_syllables, syllablesColumn: #keyPath(WordVariants.last_two_syllables))
	}
	
	private class func createFetchResultsControllerForRhymeType(
		context: NSManagedObjectContext,
		predicate: NSPredicate) -> NSFetchedResultsController<NSDictionary> {
		
		let request = NSFetchRequest<NSDictionary>(entityName: "WordVariants")
		request.propertiesToFetch = [#keyPath(WordVariants.word)]
		request.resultType = .dictionaryResultType
		request.returnsDistinctResults = true
		request.sortDescriptors = [NSSortDescriptor(key: #keyPath(WordVariants.word), ascending: true)]
		request.predicate = predicate
		return NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil)
	}
	
}
