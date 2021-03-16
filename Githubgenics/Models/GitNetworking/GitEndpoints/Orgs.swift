//
//  Orgs.swift
//  Githubgenics
//
//  Created by Ali Fayed on 22/02/2021.
//

struct Orgs {
    let orgName: String
    let orgDescription: String?

    enum Orgs: String, CodingKey {
        case orgName = "login"
        case orgDescription = "description"
    }
}

extension Orgs: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Orgs.self)
        orgName = try container.decode(String.self, forKey: .orgName)
        orgDescription = try container.decode(String.self, forKey: .orgDescription)
    }
}

//struct ListORgs {
//    let orgName: String
//    let orgDescription: String?
//    let orgAvatar
//
//    enum Orgs: String, CodingKey {
//        case orgName = "login"
//        case orgDescription = "description"
//    }
//}
