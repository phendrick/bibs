extension String {
    func toPaddedNumber() -> String {
        guard self.count < 2 else {
            return self
        }
        let padded = String(self.reversed()).padding(toLength: 2, withPad: "0", startingAt: 0).reversed()
        
        return String(padded)
    }
    
    func pluralize(count: Int) -> String {
        guard count > 0 else {
            return "\(self)s"
        }
        
        return count < 2 ? self : "\(self)s"
    }
}
