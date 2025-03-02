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


    public func getTradeBy(symbol: String) {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let params = PythonObject(["timestamp": timestamp])
        let pySymbol = PythonObject([symbol])

        print("Fetching positions for:", pySymbol)

        let positions = exchange.fetchPositions(pySymbol, params)
        
        print("Positions received:", positions)
    }


}
