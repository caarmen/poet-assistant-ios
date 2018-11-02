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

class Stems: NSManagedObject {
	
	// When looking up random words, their "frequency" is a factor in the selection.
	// Words which are too frequent (a, the, why) are not interesting words.
	// Words which are too rare (aalto) are likely not interesting either.
	private static let MIN_INTERESTING_FREQUENCY = 1500
	private static let MAX_INTERESTING_FREQUENCY = 25000
	
	class func findClosestWord(word: String, context: NSManagedObjectContext) -> String? {
		let stem = PorterStemmer().stemWord(word: word)
		let similarWords = fetchWordsWithStem(context: context, stem: stem)
		return findClosestWord(word:word, similarWords:similarWords)
	}
	
	class func findClosestWord(word: String, similarWords:[String]) -> String? {
		var closestWord: String? = nil
		var bestScore = 0
		
		similarWords.forEach { similarWord in
			let score = calculateSimilarityScore(word1: word, word2: similarWord)
			if (score > bestScore) {
				closestWord = similarWord
				bestScore = score
			}
		}
		return closestWord
	}
	
	private class func fetchWordsWithStem(context: NSManagedObjectContext, stem: String) -> [String] {
		let request: NSFetchRequest<Stems> = Stems.fetchRequest()
		request.predicate = NSPredicate(format: "\(#keyPath(Stems.stem)) = %@", stem)
		do {
			return try request.execute().filter { $0.word != nil}.map { $0.word! }
		} catch let error {
			print("Error finding words with stem \(stem): \(error)")
			return []
		}
	}
	
	/**
	For now, the score is simply the number of letters in common
	between the two words, starting from the beginning.
	*/
	class func calculateSimilarityScore(word1: String, word2: String) -> Int {
		let length = min(word1.count, word2.count)
		return (0..<length).first(where: { word1[$0] != word2[$0] }) ?? length
	}
	
	class func findRandomWord(context: NSManagedObjectContext) -> String {
		let request: NSFetchRequest<Stems> = Stems.fetchRequest()
		request.predicate = NSPredicate(format: "\(#keyPath(Stems.google_ngram_frequency)) > %d AND \(#keyPath(Stems.google_ngram_frequency)) < %d", MIN_INTERESTING_FREQUENCY, MAX_INTERESTING_FREQUENCY)
		request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Stems.word), ascending: true)]
		do {
			let result = try request.execute()
			if let word = result.randomElement()?.word {
				return word
			}
		} catch let error {
			print ("Error finding random word: \(error)")
		}
		return "error" // why not
	}
}
