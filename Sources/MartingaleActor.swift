import Foundation


actor MartingaleActor {
    private var bingxApi: BingxApiController?

    public func startSystem(symbol: String, vwapStartTime: Date) -> String {
        let vwapStartTimestamp = Int(vwapStartTime.timeIntervalSince1970 * 1000)

        bingxApi = BingxApiController()
        guard let bingxApi = bingxApi else {
            return ""
        }
        
        let trade = bingxApi.getTradeBy(symbol: symbol)
        guard let trade = trade else {
            return ""
        }
        
        let avgPrice = trade.info.avgPrice

        return "aaa"
    }
}
