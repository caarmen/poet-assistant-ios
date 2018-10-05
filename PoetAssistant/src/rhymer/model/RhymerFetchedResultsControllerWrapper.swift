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
class RhymerFetchedResultsControllerWrapper {
	private var fetchedResultsControllers = [NSFetchedResultsController<NSDictionary>]()
	private var sectionIndexTitles = [String]()
	
	var sections = [NSFetchedResultsSectionInfo]()
	
	func add(sectionTitle: String, fetchedResultsController: NSFetchedResultsController<NSDictionary>) {
		fetchedResultsControllers.append(fetchedResultsController)
		sectionIndexTitles.append(sectionTitle)
	}
	
	func object(at: IndexPath) -> NSDictionary {
		let indexPath = IndexPath(row: at.row, section: 0)
		return fetchedResultsControllers[at.section].object(at: indexPath)
	}
	
	func performFetch() throws {
		for (index, fetchedResultsController) in fetchedResultsControllers.enumerated() {
			do {
				try fetchedResultsController.performFetch()
				if let thisControllerSections = fetchedResultsController.sections, thisControllerSections.count == 1 {
					let sectionInfo = SectionInfo(
						name: sectionIndexTitles[index],
						numberOfObjects: thisControllerSections[0].numberOfObjects,
						objects: thisControllerSections[0].objects)
					sections.append(sectionInfo)
				}
				
			} catch let error {
				throw error
			}
		}
		removeEmptySections()
	}
	
	private func removeEmptySections() {
		for (index, section) in sections.enumerated().reversed() {
			if section.numberOfObjects == 0 {
				fetchedResultsControllers.remove(at: index)
				sections.remove(at: index)
				sectionIndexTitles.remove(at:index)
			}
		}
	}
}
