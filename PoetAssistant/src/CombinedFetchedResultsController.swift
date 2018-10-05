//
//  CombinedFetchedResultsController.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 05/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import CoreData


//
// Probably inefficient way to combine multiple FetchedResultsController into a single class with almost the
// same api as FetchedResultsController.
// This only aggregates NSFetchedResultsControllers which each have one section.
//
class CombinedFetchedResultsController<T: NSFetchRequestResult> {
	private var fetchedResultsControllers = [NSFetchedResultsController<T>]()
	var sectionIndexTitles = [String]()
	
	var sections: [NSFetchedResultsSectionInfo]? {
		get {
			var result = [NSFetchedResultsSectionInfo]()

			for (index, fetchedResultController) in fetchedResultsControllers.enumerated() {
				if let sections = fetchedResultController.sections, sections.count == 1 {
					let sectionInfo = SectionInfo(name: sectionIndexTitles[index], numberOfObjects: sections[0].numberOfObjects, objects: sections[0].objects)
					result.append(sectionInfo)

				}
			}
			return result
		}
	}

	func add(sectionTitle: String, fetchedResultsController: NSFetchedResultsController<T>) {
		fetchedResultsControllers.append(fetchedResultsController)
		sectionIndexTitles.append(sectionTitle)
	}
	
	func object(at: IndexPath) -> T {
		let indexPath = IndexPath(row: at.row, section: 0)
		return fetchedResultsControllers[at.section].object(at: indexPath)
	}
	
	func section(forSectionIndexTitle: String, at: Int) -> Int {
		return at
	}
	
	func performFetch() throws {
		for fetchedResultsController in fetchedResultsControllers {
			do {
				try fetchedResultsController.performFetch()
			} catch let error {
				throw error
			}
		}
	}
}

class SectionInfo : NSFetchedResultsSectionInfo {
	init(name: String, numberOfObjects: Int, objects: [Any]?) {
		self.name = name
		self.indexTitle = name
		self.numberOfObjects = numberOfObjects
		self.objects = objects
	}
	var name: String
	
	var indexTitle: String?
	
	var numberOfObjects: Int
	
	var objects: [Any]?
	
	
}
