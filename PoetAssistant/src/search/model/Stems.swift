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
		for (index, _) in word1.enumerated() {
			if index >= word2.count || word1[index] != word2[index] {
				return index
			}
		}
		return length
	}
}
