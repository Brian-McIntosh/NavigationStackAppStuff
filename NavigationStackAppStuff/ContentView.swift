//
//  ContentView.swift
//  NavigationStackAppStuff
//
//  Created by Brian McIntosh on 3/9/23.
//

import SwiftUI

// #4a - setting up model of dummy data
// (don't forget Identifiable - needed by List)
// (you'll need Hasable when you get to value-based Navigation)
struct CarBrand: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

// #6a - setting up model of dummy data
struct Car: Identifiable, Hashable {
    let id = UUID()
    let make: String
    let model: String
    let year: Int
    
    var description: String { //<-- computed property just like in NetworkManager.description and .imageName
        return "\(year) \(make) \(model)"
    }
}

struct ContentView: View {
    
    // #4b - add array of some dummy data
    let carBrands: [CarBrand] = [
        .init(name: "Ford"),
        .init(name: "GM"),
        .init(name: "Toyota"),
        .init(name: "Chrysler")
    ]
    
    // #6b - add more data to test diff destination modifier
    let cars: [Car] = [
        .init(make: "Ford", model: "Escape", year: 2022),
        .init(make: "GM", model: "Trailblazer", year: 1996),
        .init(make: "Chrysler", model: "SeaBreeze", year: 2002)
    ]
    
    // #20! one last very cool feature: Navigation path
    @State private var navigationPath = [CarBrand]()
    
    var body: some View {
        VStack {
            
            // #1
            // old way - deprecated NavigationView
            //NavigationView {
            
            // #2
            // So instead, use Stack
            NavigationStack(path: $navigationPath) {
                
                NavigationLink("I am a NavigationLink.") {
                    Text("I'm the view you navigate to.")
                        .font(.title)
                }
                // ^^ #3
                // ^^ Note how we used title: destination:
                // NavigationLink(<#T##title: StringProtocol##StringProtocol#>, destination: <#T##() -> View#>)
                
                // #4 Let's create DATA for a LIST to explore more Navigation options
                // #4a - ^ go up top and create the model of some dummy data
                // #4b - ^ add array of some dummy data
                
                // #5
                List {
                    Section("Manufacturers") {
                        ForEach(carBrands) { brand in
                            
                            //Text(brand.name) <--for testing: just pass in the brand as the value
                            //Replace w/ Link...
                            
                            NavigationLink(value: brand) {
                                Text(brand.name)
                            }
                            // ^^ does NOT navigate anywhere yet until we add destination modifier
                            // NavigationLink(value: <#T##(Decodable & Encodable & Hashable)?#>, label: <#T##() -> View#>)
                            // ^^ NEW value-based, data-driven option when creating...
                        }
                    }
                    
                    // #6 Let's create more data for different destination modifiers
                    // #6a - ^ go up top and create the model of some dummy data
                    // #6b - ^ add array of some dummy data
                    Section("Cars") {
                        ForEach(cars) { car in
                            NavigationLink(value: car) {
                                Text(car.description)
                            }
                        }
                        // ^^ does NOT navigate b/c dest mod doesn't recognize Car object/value
                    }
                    
                    // NOTE at this point, our 2 list section are associated with its own particular data set and data structure - Manufacturers and Cars
                }
                .navigationDestination(for: CarBrand.self) { brand in
                    //Text("New \(brand.name)")
                    viewForBrand(brand: brand)
                }
                // ^^ NEW
                //.navigationDestination(for: <#T##Hashable.Protocol#>, destination: <#T##(Hashable) -> View#>)
                .navigationDestination(for: Car.self) { car in
                    ZStack {
                        Color(.systemRed)
                        Text(car.description)
                    }
                }
                // ^^ NEW demonstrating multiple navigation destination modifiers
            }
        }
        .padding()
    }
    
    // ^^ NEW function to act as a View Router!! :)
    func viewForBrand(brand: CarBrand) -> AnyView {
        
//        if brand.name == "Ford" {
//            return AnyView(Color(.systemBlue))
//        }else if brand.name == "GM"{
//            return AnyView(Color(.systemIndigo))
//        }else{
//            return AnyView(Color(.systemGray))
//        }
        
        // SAME AS ABOVE
        switch brand.name { //<--typically from Enum
        case "Ford":
            return AnyView(Color(.systemBlue))
        case "GM":
            return AnyView(Color(.systemIndigo))
        case "Toyota":
            return AnyView(Color(.systemYellow))
        case "Chrysler":
            return AnyView(Color(.systemPurple))
        default:
            return AnyView(Color(.systemGray))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
