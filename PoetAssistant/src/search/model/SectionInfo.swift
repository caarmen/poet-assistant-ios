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
