import UIKit


//: ## 1. Create custom types to represent an Airport Departures display
//: ![Airport Departures](matthew-smith-5934-unsplash.jpg)
//: Look at data from [Departures at JFK Airport in NYC](https://www.airport-jfk.com/departures.php) for reference.
//:
//: a. Use an `enum` type for the FlightStatus (En Route, Scheduled, Canceled, Delayed, etc.)
//:
//: b. Use a struct to represent an `Airport` (Destination or Arrival)
//:
//: c. Use a struct to represent a `Flight`.
//:
//: d. Use a `Date?` for the departure time since it may be canceled.
//:
//: e. Use a `String?` for the Terminal, since it may not be set yet (i.e.: waiting to arrive on time)
//:
//: f. Use a class to represent a `DepartureBoard` with a list of departure flights, and the current airport
enum FlightStatus: String {
    case enroute = "En Route"
    case scheduled = "Scheduled"
    case canceled = "Canceled"
    case delayed = "Delayed"
    case landed = "Landed"
    case boarding = "Boarding"
}

struct Airport {
    let city: String
}

struct Flight {
    let destination: Airport
    let airline: String
    let flightName: String
    let departureTime: Date?
    let terminal: String?
    let status: FlightStatus
}

class DepartureBoard {
    private (set) var departures: [Flight]
    var currentAirport: Airport
    
    init() {
        departures = []
        currentAirport = Airport(city: "New York City (JFK)")
    }
    
    func addFlight(flight: Flight) {
        departures.append(flight)
    }
    
    func alertPassengers() {
        var departureTime: String
        var terminal: String
        
        let departureDateFormatter = DateFormatter()
        departureDateFormatter.timeStyle = .short
        departureDateFormatter.dateStyle = .none
        
        for departure in departures {
            
            if let time = departure.departureTime {
                departureTime = departureDateFormatter.string(from: time)
            } else {
                departureTime = "TBD"
            }
            
            if let departureTerminal = departure.terminal {
                terminal = "\(departureTerminal)"
            
                switch departure.status {
                case .canceled:
                    print("We're sorry your flight to \(departure.destination.city) was canceled, here is a $500 voucher.")
                case .enroute:
                    print("Your flight to \(departure.destination.city) is en route. Hope you're on it :)")
                case .scheduled:
                    print("Your flight to \(departure.destination.city) is scheduled to depart at \(departureTime) from terminal: \(terminal).")
                case .boarding:
                    print("Your flight is boarding, please head to terminal: \(terminal) immediately. The doors are closing soon.")
                case .delayed:
                    print("We're sorry your flight to \(departure.destination.city) has been delayed, here is a open, half-full bag of pretzels.")
                default:
                    print("Your flight has already landed")
                }
            } else {
                print("Please seek the nearest information desk for more details.")
            }
        }
    }
}

//: ## 2. Create 3 flights and add them to a departure board
//: a. For the departure time, use `Date()` for the current time
//:
//: b. Use the Array `append()` method to add `Flight`'s
//:
//: c. Make one of the flights `.canceled` with a `nil` departure time
//:
//: d. Make one of the flights have a `nil` terminal because it has not been decided yet.
//:
//: e. Stretch: Look at the API for [`DateComponents`](https://developer.apple.com/documentation/foundation/datecomponents?language=objc) for creating a specific time
let flightBoard = DepartureBoard()

var flight1Date: Date?
var flight3Date: Date?

let calendar = Calendar.current
let flight1DateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current, year: 2019, month: 5, day: 30, hour: 17, minute: 30)
let flight3DateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current, year: 2019, month: 5, day: 30, hour: 20, minute: 00)

flight1Date = calendar.date(from: flight1DateComponents)
flight3Date = calendar.date(from: flight3DateComponents)


let airport1 = Airport(city: "Los Angeles (LAX)")
let airport2 = Airport(city: "Tokyo (NRT)")
let airport3 = Airport(city: "Las Vegas (LAS)")

let flight1 = Flight(destination: airport1, airline: "Delta Air Lines", flightName: "DL 423", departureTime: flight1Date, terminal: "4", status: .enroute)
let flight2 = Flight(destination: airport2, airline: "United Airlines", flightName: "UA 7998", departureTime: nil, terminal: "7", status: .canceled)
let flight3 = Flight(destination: airport3, airline: "JetBlue Airways", flightName: "B6 2611", departureTime: flight3Date, terminal: nil, status: .landed)

flightBoard.addFlight(flight: flight1)
flightBoard.addFlight(flight: flight2)
flightBoard.addFlight(flight: flight3)

//: ## 3. Create a free-standing function that can print the flight information from the `DepartureBoard`
//: a. Use the function signature: `printDepartures(departureBoard:)`
//:
//: b. Use a `for in` loop to iterate over each departure
//:
//: c. Make your `FlightStatus` enum conform to `String` so you can print the `rawValue` String values from the `enum`. See the [enum documentation](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html).
//:
//: d. Print out the current DepartureBoard you created using the function
func printDepatures(departureBoard: DepartureBoard) {
    var departureTime: String
    var terminal: String
    
    let departureDateFormatter = DateFormatter()
    departureDateFormatter.timeStyle = .short
    departureDateFormatter.dateStyle = .none
    
    for departure in departureBoard.departures {
        if let time = departure.departureTime {
            departureTime = departureDateFormatter.string(from: time)
        } else {
            departureTime = ""
        }
        
        if let departureTerminal = departure.terminal {
            terminal = "\(departureTerminal)"
        } else {
            terminal = ""
        }
        
        print("Destination: \(departure.destination.city)\nAirline: \(departure.airline)\nFlight: \(departure.flightName)\nDeparture Time: \(departureTime)\nTerminal: \(terminal)\nStatus: \(departure.status.rawValue)\n")
    }
}

printDepatures(departureBoard: flightBoard)

//: ## 4. Make a second function to print print an empty string if the `departureTime` is nil
//: a. Createa new `printDepartures2(departureBoard:)` or modify the previous function
//:
//: b. Use optional binding to unwrap any optional values, use string interpolation to turn a non-optional date into a String
//:
//: c. Call the new or udpated function. It should not print `Optional(2019-05-30 17:09:20 +0000)` for departureTime or for the Terminal.
//:
//: d. Stretch: Format the time string so it displays only the time using a [`DateFormatter`](https://developer.apple.com/documentation/foundation/dateformatter) look at the `dateStyle` (none), `timeStyle` (short) and the `string(from:)` method
//:
//: e. Your output should look like:
//:
//:     Destination: Los Angeles Airline: Delta Air Lines Flight: KL 6966 Departure Time:  Terminal: 4 Status: Canceled
//:     Destination: Rochester Airline: Jet Blue Airways Flight: B6 586 Departure Time: 1:26 PM Terminal:  Status: Scheduled
//:     Destination: Boston Airline: KLM Flight: KL 6966 Departure Time: 1:26 PM Terminal: 4 Status: Scheduled
// Function above in previous question

//: ## 5. Add an instance method to your `DepatureBoard` class (above) that can send an alert message to all passengers about their upcoming flight. Loop through the flights and use a `switch` on the flight status variable.
//: a. If the flight is canceled print out: "We're sorry your flight to \(city) was canceled, here is a $500 voucher"
//:
//: b. If the flight is scheduled print out: "Your flight to \(city) is scheduled to depart at \(time) from terminal: \(terminal)"
//:
//: c. If their flight is boarding print out: "Your flight is boarding, please head to terminal: \(terminal) immediately. The doors are closing soon."
//:
//: d. If the `departureTime` or `terminal` are optional, use "TBD" instead of a blank String
//:
//: e. If you have any other cases to handle please print out appropriate messages
//:
//: d. Call the `alertPassengers()` function on your `DepartureBoard` object below
//:
//: f. Stretch: Display a custom message if the `terminal` is `nil`, tell the traveler to see the nearest information desk for more details.
// Function above in class
flightBoard.alertPassengers()


//: ## 6. Create a free-standing function to calculate your total airfair for checked bags and destination
//: Use the method signature, and return the airfare as a `Double`
//:
//:     func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
//:     }
//:
//: a. Each bag costs $25
//:
//: b. Each mile costs $0.10
//:
//: c. Multiply the ticket cost by the number of travelers
//:
//: d. Call the function with a variety of inputs (2 bags, 2000 miles, 3 travelers = $750)
//:
//: e. Make sure to cast the numbers to the appropriate types so you calculate the correct airfare
//:
//: f. Stretch: Use a [`NumberFormatter`](https://developer.apple.com/documentation/foundation/numberformatter) with the `currencyStyle` to format the amount in US dollars.

func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> String {
    var airfareCost = 0.0
    let bagCost = 25.0
    let perMileCost = 0.1
    
    airfareCost = bagCost * Double(checkedBags)
    airfareCost = airfareCost + perMileCost * Double(distance)
    airfareCost = airfareCost * Double(travelers)
    
    let usdFormatter = NumberFormatter()
    usdFormatter.numberStyle = .currency
    if let formattedValue = usdFormatter.string(from: NSNumber(value: airfareCost)) {
        return formattedValue
    } else {
        return "\(airfareCost)"
    }
}

calculateAirfare(checkedBags: 2, distance: 2000, travelers: 3)
