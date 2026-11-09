enum PlanType: String,CaseIterable,Identifiable {
    case steady , progressive , interval
    var id: String {self.rawValue}
}
