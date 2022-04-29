//
//  ContentView.swift
//  DependencyInjection
//
//  Created by Federico on 29/04/2022.
//

import SwiftUI

//MARK: - Data model

struct Person {
    var name: String
    var age: Int
}

protocol PeopleDataProtocol {
    func getPeople() -> [Person]
}

//MARK: - Class to be injected
class DataUpdater: PeopleDataProtocol {
    // Real data receiver
    func getPeople() -> [Person] {
        return [Person(name: "Mario", age: 20),
                Person(name: "Luigi", age: 22),
                Person(name: "Toad", age: 12)]
    }
}

//MARK: - Class to be injected
class MockUpdater: PeopleDataProtocol {
    // Mock data receiver
    func getPeople() -> [Person] {
        var tempList = [Person]()
        
        for i in 1...20 {
            let person = Person(name: "Person \(i)", age: Int.random(in: 12...70))
            tempList.append(person)
        }
        
        return tempList
    }
}

//MARK: - ViewModel
final class ViewModel: ObservableObject {
    @Published var people: [Person]
    let peopleData: PeopleDataProtocol
    
    init(peopleData: PeopleDataProtocol) {
        self.peopleData = peopleData
        self.people = peopleData.getPeople()
    }
}

struct ContentView: View {
    @StateObject private var vm = ViewModel(peopleData: MockUpdater())
    
    var body: some View {
        VStack {
            List(vm.people, id: \.name) { person in
                HStack {
                    Text("\(person.name)")
                        .font(.callout)
                    Spacer()
                    Text("\(person.age)")
                        .font(.caption)
                }
            }
            .listStyle(.inset)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
