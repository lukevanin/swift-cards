//
//  CardImageFactory.swift
//  Cards
//
//  Created by Luke Van In on 2021/05/26.
//

import UIKit

import Deck


enum CardImageFactoryError: Error {
    case cannotLoadCard
}


protocol CardImageFactory {
    associatedtype Card: AbstractCard
    func image(for card: Card, size: CGSize) throws -> UIImage
}
