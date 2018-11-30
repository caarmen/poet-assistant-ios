// Random number generator based on https://android.googlesource.com/platform/dalvik/+/f87ab9616697b8bae08c5e8007cbdd0039a1f8ce/libcore/luni/src/main/java/java/util/Random.java

// https://stackoverflow.com/questions/41202147/unsigned-right-shift-operator-in-swift
infix operator >>>
func >>> (lhs: Int64, rhs: Int64) -> Int64 {
	return Int64(bitPattern: UInt64(bitPattern: lhs) >> UInt64(rhs))
}
class Random {
	var seed: Int64
	private let multiplier = Int64(0x5deece66d)
	init(inputSeed: Int64?) {
		if inputSeed != nil {
			self.seed = Random.createSeed(inputSeed: inputSeed!, multiplier: multiplier)
		} else {
			self.seed = Random.createSeed(inputSeed: Int64(Date().timeIntervalSince1970 * 1000), multiplier: multiplier)
		}
	}
	
	private class func createSeed(inputSeed: Int64, multiplier: Int64) -> Int64 {
		return (inputSeed ^ multiplier) & ((Int64(1) << 48) - 1)
	}
	
	func nextInt(_ n: Int64) -> Int64 {
		if ((n & -n) == n) {
			return Int64((n &* next(bits:31) >> 31))
		}
		var bits: Int64
		var val: Int64
		repeat {
			bits = next(bits:31)
			val = bits % n
		} while (bits - val &+ (n - 1) < 0)
		return val
	}
	private func next(bits: Int64) -> Int64 {
		let a = self.seed &* self.multiplier
		let b = Int64(0xb)
		let c = ((Int64(1) << 48) - 1)
		self.seed = (a &+ b) & c;
		return (seed >>> (48 - bits))
	}
}
