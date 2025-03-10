import Foundation
import PythonKit

public class BingxApiController {
    private let apiKey: String
    private let apiSecret: String
    private let exchange: PythonObject

    init () {
        setenv("PYTHONHOME", "/opt/homebrew/opt/python@3.13/Frameworks/Python.framework/Versions/3.13", 1)
        setenv("PYTHONPATH", "/Users/jannicmarcon/Documents/GitHub/AntiMartingaleSystem/python_env/lib/python3.13/site-packages", 1)

        PythonLibrary.useLibrary(at: "/opt/homebrew/opt/python@3.13/Frameworks/Python.framework/Versions/3.13/lib/libpython3.13.dylib")
        
        apiKey = ProcessInfo.processInfo.environment["BINGX_API_KEY"] ?? ""
        apiSecret = ProcessInfo.processInfo.environment["BINGX_API_SECRET"] ?? ""
        
        let ccxt = Python.import("ccxt")
        exchange = ccxt.bingx([
            "apiKey": apiKey,
            "secret": apiSecret,
        ])

        exchange.options["defaultType"] = "swap"
    }


    func getTradeBy(symbol: String) -> PositionResponse? {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let params = PythonObject(["timestamp": timestamp])
        let pySymbol = PythonObject([symbol])

        let positions = exchange.fetchPositions(pySymbol, params)

        do {
            let jsonString = Python.import("json").dumps(positions)

            // Convert JSON string to Data
            if let jsonData = jsonString.description.data(using: .utf8) {
                // Decode into Swift struct
                let decodedPositions = try JSONDecoder().decode([PositionResponse].self, from: jsonData)
                return decodedPositions.first
            } else {
                print("Failed to convert JSON string to Data: getTradeBy")
            }
        } catch {
            print("error on getTradeBy(symbol): Error: \(error)")
        }

        return nil
    }

    func getCandles(symbol: String, since: Int, limit: Int = 1000, timeframe: String = "1m") -> [Candle] {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let params = PythonObject(["timestamp": timestamp])

        let pySymbol = PythonObject(symbol)
        let pySince = PythonObject(since)
        let pyTimeframe = PythonObject(timeframe)
        let pyLimit = PythonObject(limit)
        
        let exchangeResponse = exchange.fetchOHLCV(symbol: pySymbol, timeframe: pyTimeframe, since: pySince, limit: pyLimit, params: params)
        
        do {
            let jsonString = Python.import("json").dumps(exchangeResponse)
            
            if let jsonData = jsonString.description.data(using: .utf8) {
                // Decode JSON as an array of arrays, then map it to Candle structs
                let rawCandles = try JSONDecoder().decode([[Double]].self, from: jsonData)

                let candles = rawCandles.map { array -> Candle in
                    return Candle(
                        timestamp: Int(array[0]),
                        open: array[1],
                        high: array[2],
                        low: array[3],
                        close: array[4],
                        volume: array[5]
                    )
                }

                return candles
            } else {
                print("Failed to convert JSON string to Data: getCandles")
            }
        } catch {
            print("error on getCandles(): Error: \(error)")
        }
        
        return []
    }

}
