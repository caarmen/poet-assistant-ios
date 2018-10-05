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

// TODO copypaste
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
