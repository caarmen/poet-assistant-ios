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

import XCTest
@testable import PoetAssistant
class WotdTest: XCTestCase {
	
	func testWotd() {
		// The expected words come from the wotd feature of the Android app
		assertWotd(dateString: "20181124", expectedWotd:"vaccinate")
		assertWotd(dateString: "20181123", expectedWotd:"devaluation")
		assertWotd(dateString: "20181122", expectedWotd:"copulation")
		assertWotd(dateString: "20181121", expectedWotd:"fuselage")
		assertWotd(dateString: "20181120", expectedWotd:"lyricist")
		assertWotd(dateString: "20181119", expectedWotd:"emphysema")
		assertWotd(dateString: "20181118", expectedWotd:"auscultation")
		assertWotd(dateString: "20181117", expectedWotd:"hypotonia")
		assertWotd(dateString: "20181116", expectedWotd:"brigadier")
		assertWotd(dateString: "20181115", expectedWotd:"gallstone")
		assertWotd(dateString: "20181114", expectedWotd:"unspoilt")
		assertWotd(dateString: "20181113", expectedWotd:"sprayer")
		assertWotd(dateString: "20181112", expectedWotd:"tufa")
		assertWotd(dateString: "20181111", expectedWotd:"braised")
		assertWotd(dateString: "20181110", expectedWotd:"unselfishly")
		assertWotd(dateString: "20181109", expectedWotd:"economise")
		assertWotd(dateString: "20181108", expectedWotd:"navel")
		assertWotd(dateString: "20181107", expectedWotd:"rhombus")
		assertWotd(dateString: "20181106", expectedWotd:"swinish")
		assertWotd(dateString: "20181105", expectedWotd:"offshoot")
		assertWotd(dateString: "20181104", expectedWotd:"personation")
		assertWotd(dateString: "20181103", expectedWotd:"sorrowing")
		assertWotd(dateString: "20181102", expectedWotd:"leasehold")
		assertWotd(dateString: "20181101", expectedWotd:"blowout")
		assertWotd(dateString: "20181031", expectedWotd:"dropout")
		assertWotd(dateString: "20181030", expectedWotd:"interrogatively")
		assertWotd(dateString: "20181029", expectedWotd:"indelible")
		assertWotd(dateString: "20181028", expectedWotd:"sprit")
		assertWotd(dateString: "20181027", expectedWotd:"semiotic")
		assertWotd(dateString: "20181026", expectedWotd:"normalisation")
		assertWotd(dateString: "20181025", expectedWotd:"overladen")
		assertWotd(dateString: "20181024", expectedWotd:"deist")
		assertWotd(dateString: "20181023", expectedWotd:"silviculture")
		assertWotd(dateString: "20181022", expectedWotd:"heathenism")
		assertWotd(dateString: "20181021", expectedWotd:"divisive")
		assertWotd(dateString: "20181020", expectedWotd:"unripe")
		assertWotd(dateString: "20181019", expectedWotd:"soviet")
		assertWotd(dateString: "20181018", expectedWotd:"napped")
		assertWotd(dateString: "20181017", expectedWotd:"minder")
		assertWotd(dateString: "20181016", expectedWotd:"heighten")
		assertWotd(dateString: "20181015", expectedWotd:"karat")
		assertWotd(dateString: "20181014", expectedWotd:"phosphorous")
		assertWotd(dateString: "20181013", expectedWotd:"firearm")
		assertWotd(dateString: "20181012", expectedWotd:"hypotenuse")
		assertWotd(dateString: "20181011", expectedWotd:"boldface")
		assertWotd(dateString: "20181010", expectedWotd:"recapitulate")
		assertWotd(dateString: "20181009", expectedWotd:"alchemist")
		assertWotd(dateString: "20181008", expectedWotd:"abrogate")
		assertWotd(dateString: "20181007", expectedWotd:"binnacle")
		assertWotd(dateString: "20181006", expectedWotd:"unimpressive")
		assertWotd(dateString: "20181005", expectedWotd:"insanitary")
		assertWotd(dateString: "20181004", expectedWotd:"friday")
		assertWotd(dateString: "20181003", expectedWotd:"ancestress")
		assertWotd(dateString: "20181002", expectedWotd:"badminton")
		assertWotd(dateString: "20181001", expectedWotd:"bioremediation")
		assertWotd(dateString: "20180930", expectedWotd:"servo")
		assertWotd(dateString: "20180929", expectedWotd:"mobilisation")
		assertWotd(dateString: "20180928", expectedWotd:"taproot")
		assertWotd(dateString: "20180927", expectedWotd:"relinquishing")
		assertWotd(dateString: "20180926", expectedWotd:"creosote")
		assertWotd(dateString: "20180925", expectedWotd:"autograph")
		assertWotd(dateString: "20180924", expectedWotd:"catechetical")
		assertWotd(dateString: "20180923", expectedWotd:"jib")
		assertWotd(dateString: "20180922", expectedWotd:"protraction")
		assertWotd(dateString: "20180921", expectedWotd:"ambit")
		assertWotd(dateString: "20180920", expectedWotd:"panchayat")
		assertWotd(dateString: "20180919", expectedWotd:"deb")
		assertWotd(dateString: "20180918", expectedWotd:"territorially")
		assertWotd(dateString: "20180917", expectedWotd:"hart")
		assertWotd(dateString: "20180916", expectedWotd:"downtrodden")
		assertWotd(dateString: "20180915", expectedWotd:"prolapse")
		assertWotd(dateString: "20180914", expectedWotd:"metaphysically")
		assertWotd(dateString: "20180913", expectedWotd:"substratum")
		assertWotd(dateString: "20180912", expectedWotd:"adroitly")
		assertWotd(dateString: "20180911", expectedWotd:"isi")
		assertWotd(dateString: "20180910", expectedWotd:"yardarm")
		assertWotd(dateString: "20180909", expectedWotd:"pullout")
		assertWotd(dateString: "20180908", expectedWotd:"computationally")
		assertWotd(dateString: "20180907", expectedWotd:"schoolyard")
		assertWotd(dateString: "20180906", expectedWotd:"advisedly")
		assertWotd(dateString: "20180905", expectedWotd:"maxillofacial")
		assertWotd(dateString: "20180904", expectedWotd:"belike")
		assertWotd(dateString: "20180903", expectedWotd:"storyteller")
		assertWotd(dateString: "20180902", expectedWotd:"blip")
		assertWotd(dateString: "20180901", expectedWotd:"colorist")
		assertWotd(dateString: "20180831", expectedWotd:"scythe")
		assertWotd(dateString: "20180830", expectedWotd:"timbered")
		assertWotd(dateString: "20180829", expectedWotd:"overspread")
		assertWotd(dateString: "20180828", expectedWotd:"succinct")
		assertWotd(dateString: "20180827", expectedWotd:"masochistic")
		assertWotd(dateString: "20180826", expectedWotd:"maltreatment")
		assertWotd(dateString: "20180825", expectedWotd:"dampen")
		assertWotd(dateString: "20180824", expectedWotd:"bichromate")
		assertWotd(dateString: "20180823", expectedWotd:"subluxation")
		assertWotd(dateString: "20180822", expectedWotd:"prodigiously")
		assertWotd(dateString: "20180821", expectedWotd:"superficiality")
		assertWotd(dateString: "20180820", expectedWotd:"territorially")
		assertWotd(dateString: "20180819", expectedWotd:"unconstrained")
		assertWotd(dateString: "20180818", expectedWotd:"literati")
		assertWotd(dateString: "20180817", expectedWotd:"dispossessed")
	}
	
	private func assertWotd(dateString: String, expectedWotd: String) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyyMMddZ"
		let date = dateFormatter.date(from: "\(dateString)+0000")
		let actualWotd = Wotd.getWordOfTheDay(context: AppDelegate.persistentDictionariesContainer.viewContext, date:date!)
		XCTAssertEqual(expectedWotd, actualWotd)
	}
	
}
