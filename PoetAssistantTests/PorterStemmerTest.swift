
// https://github.com/caarmen/porter-stemmer/blob/master/library/src/test/java/ca/rmen/porterstemmer/TestPorterStemmer.java

import XCTest
@testable import PoetAssistant
class PorterStemmerTest: XCTestCase {
	
	private let porterStemmer = PorterStemmer()
	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func test_getM() {
		assertGetM("tr", 0)
		assertGetM("ee", 0)
		assertGetM("tree", 0)
		assertGetM("y", 0)
		assertGetM("by", 0)
		assertGetM("trouble", 1)
		assertGetM("oats", 1)
		assertGetM("trees", 1)
		assertGetM("ivy", 1)
		assertGetM("troubles", 2)
		assertGetM("private", 2)
		assertGetM("oaten", 2)
		assertGetM("orrery", 2)
	}
	
	func test_step1a() {
		assertStep1a("caresses", "caress")
		assertStep1a("ponies", "poni")
		assertStep1a("ties", "ti")
		assertStep1a("caress", "caress")
		assertStep1a("cats", "cat")
	}
	
	func test_step1b() {
		assertStep1b("feed", "feed")
		assertStep1b("agreed", "agree")
		assertStep1b("plastered", "plaster")
		assertStep1b("bled", "bled")
		assertStep1b("motoring", "motor")
		assertStep1b("sing", "sing")
		assertStep1b("conflated", "conflate")
		assertStep1b("troubled", "trouble")
		assertStep1b("sized", "size")
		assertStep1b("hopping", "hop")
		assertStep1b("tanned", "tan")
		assertStep1b("falling", "fall")
		assertStep1b("hissing", "hiss")
		assertStep1b("fizzed", "fizz")
		assertStep1b("failing", "fail")
		assertStep1b("filing", "file")
	}
	
	func test_step1c() {
		assertStep1c("happy", "happi")
		assertStep1c("sky", "sky")
	}
	func test_step2() {
		assertStep2("relational", "relate")
		assertStep2("conditional", "condition")
		assertStep2("rational", "rational")
		assertStep2("valenci", "valence")
		assertStep2("hesitanci", "hesitance")
		assertStep2("digitizer", "digitize")
		assertStep2("conformabli", "conformable")
		assertStep2("radicalli", "radical")
		assertStep2("differentli", "different")
		assertStep2("vileli", "vile")
		assertStep2("analogousli", "analogous")
		assertStep2("vietnamization", "vietnamize")
		assertStep2("predication", "predicate")
		assertStep2("operator", "operate")
		assertStep2("feudalism", "feudal")
		assertStep2("decisiveness", "decisive")
		assertStep2("hopefulness", "hopeful")
		assertStep2("callousness", "callous")
		assertStep2("formaliti", "formal")
		assertStep2("sensitiviti", "sensitive")
		assertStep2("sensibiliti", "sensible")
	}
	
	func test_step3() {
		assertStep3("triplicate","triplic")
		assertStep3("formative","form")
		assertStep3("formalize","formal")
		assertStep3("electriciti","electric")
		assertStep3("electrical","electric")
		assertStep3("hopeful","hope")
		assertStep3("goodness","good")
	}
	
	func test_step4() {
		assertStep4("revival","reviv")
		assertStep4("allowance","allow")
		assertStep4("inference","infer")
		assertStep4("airliner","airlin")
		assertStep4("gyroscopic","gyroscop")
		assertStep4("adjustable","adjust")
		assertStep4("defensible","defens")
		assertStep4("irritant","irrit")
		assertStep4("replacement","replac")
		assertStep4("adjustment","adjust")
		assertStep4("dependent","depend")
		assertStep4("adoption","adopt")
		assertStep4("homologou","homolog")
		assertStep4("communism","commun")
		assertStep4("activate","activ")
		assertStep4("angulariti","angular")
		assertStep4("homologous","homolog")
		assertStep4("effective","effect")
		assertStep4("bowdlerize","bowdler")
	}
	
	func test_step5a() {
		assertStep5a("probate", "probat")
		assertStep5a("rate", "rate")
		assertStep5a("cease", "ceas")
	}
	
	func test_step5b() {
		assertStep5b("controll", "control")
		assertStep5b("roll", "roll")
	}
	private func assertGetM(_ word: String, _ expectedM: Int) {
		let letterTypes = porterStemmer.getLetterTypes(word)
		let actualM = porterStemmer.getM(letterTypes)
		XCTAssertEqual(expectedM, actualM, "Expected \(expectedM) for word \(word) but got \(actualM)")
	}
	
	private func assertStep1a(_ input: String, _ expectedOutput: String) {
		let actualOutput = porterStemmer.stemStep1a(input)
		XCTAssertEqual(expectedOutput, actualOutput, "Expected \(input) -> \(expectedOutput) for step 1a, but got \(actualOutput)")
	}
	
	private func assertStep1b(_ input: String, _ expectedOutput: String) {
		let actualOutput = porterStemmer.stemStep1b(input)
		XCTAssertEqual(expectedOutput, actualOutput, "Expected \(input) -> \(expectedOutput) for step 1b, but got \(actualOutput)")
	}
	
	private func assertStep1c(_ input: String, _ expectedOutput: String) {
		let actualOutput = porterStemmer.stemStep1c(input)
		XCTAssertEqual(expectedOutput, actualOutput, "Expected \(input) -> \(expectedOutput) for step 1c, but got \(actualOutput)")
	}
	
	private func assertStep2(_ input: String, _ expectedOutput: String) {
		let actualOutput = porterStemmer.stemStep2(input)
		XCTAssertEqual(expectedOutput, actualOutput, "Expected \(input) -> \(expectedOutput) for step 2, but got \(actualOutput)")
	}
	private func assertStep3(_ input: String, _ expectedOutput: String) {
		let actualOutput = porterStemmer.stemStep3(input)
		XCTAssertEqual(expectedOutput, actualOutput, "Expected \(input) -> \(expectedOutput) for step 3, but got \(actualOutput)")
	}
	private func assertStep4(_ input: String, _ expectedOutput: String) {
		let actualOutput = porterStemmer.stemStep4(input)
		XCTAssertEqual(expectedOutput, actualOutput, "Expected \(input) -> \(expectedOutput) for step 4, but got \(actualOutput)")
	}
	private func assertStep5a(_ input: String, _ expectedOutput: String) {
		let actualOutput = porterStemmer.stemStep5a(input)
		XCTAssertEqual(expectedOutput, actualOutput, "Expected \(input) -> \(expectedOutput) for step 5a, but got \(actualOutput)")
	}
	private func assertStep5b(_ input: String, _ expectedOutput: String) {
		let actualOutput = porterStemmer.stemStep5b(input)
		XCTAssertEqual(expectedOutput, actualOutput, "Expected \(input) -> \(expectedOutput) for step 5b, but got \(actualOutput)")
	}
}
