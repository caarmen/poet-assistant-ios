//
//  SectionInfo.swift
//  PoetAssistant
//
//  Created by Carmen Alvarez on 05/10/2018.
//  Copyright © 2018 Carmen Alvarez. All rights reserved.
//

import CoreData

// Strange that there's no default implentation of this protocol...
class SectionInfo : NSFetchedResultsSectionInfo {
	init(name: String, numberOfObjects: Int, objects: [Any]?) {
		self.name = name
		self.indexTitle = name // We don't care about index titles: just set it to the name
		self.numberOfObjects = numberOfObjects
		self.objects = objects
	}
	var name: String
	var indexTitle: String?
	var numberOfObjects: Int
	var objects: [Any]?
}
