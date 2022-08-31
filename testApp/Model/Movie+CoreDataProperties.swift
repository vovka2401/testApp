//
//  Movie+CoreDataProperties.swift
//  testApp
//
//  Created by Volodymyr Khvaliuk on 31.08.2022.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var year: Int16
    @NSManaged public var title: String?

}

extension Movie : Identifiable {

}
