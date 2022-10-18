//
//  LocalService.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 14/10/22.
//

import UIKit
import CoreData

class LocalService {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteGameModel")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("CoreData container error: \(error!)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getAllFavorite() async -> [Detail] {
        let taskContext = newTaskContext()
        var games = [Detail]()
        do {
            try await taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
                let results = try taskContext.fetch(fetchRequest)
                results.forEach { result in
                    let game = Detail(
                        id: result.value(forKeyPath: "id") as? Int ?? 0,
                        name: result.value(forKeyPath: "title") as? String ?? "",
                        description: result.value(forKeyPath: "gameDesc") as? String ?? "",
                        backgroundImage: URL(string: result.value(forKeyPath: "image") as? String ?? ""),
                        gamesCount: result.value(forKeyPath: "gameCount") as? Int ?? 0,
                        rating: result.value(forKeyPath: "gameRating") as? Double ?? 0.0,
                        releasedDate: result.value(forKeyPath: "releaseDate") as? String
                    )
                    games.append(game)
                }
            }
        } catch {
            print(error)
        }
        return games
    }
    
    func getFavorite(id: Int) async -> Detail? {
        let taskContext = newTaskContext()
        var game: Detail?
        do {
            try await taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                
                if let result = try taskContext.fetch(fetchRequest).first {
                    let gameResult = Detail(
                        id: result.value(forKeyPath: "id") as? Int ?? 0,
                        name: result.value(forKeyPath: "title") as? String ?? "",
                        description: result.value(forKeyPath: "gameDesc") as? String ?? "",
                        backgroundImage: URL(string: result.value(forKeyPath: "image") as? String ?? ""),
                        gamesCount: result.value(forKeyPath: "gameCount") as? Int ?? 0,
                        rating: result.value(forKeyPath: "gameRating") as? Double ?? 0.0,
                        releasedDate: result.value(forKeyPath: "releaseDate") as? String
                    )
                    game = gameResult
                }
            }
        } catch {
            print(error)
        }
        return game
    }
    
    func addFavorite(
        _ id: Int,
        _ name: String,
        _ description: String,
        _ image: URL,
        _ releaseDate: String,
        _ rating: Double,
        _ gameCount: Int,
        completion: @escaping () -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(id, forKeyPath: "id")
                game.setValue(name, forKeyPath: "title")
                game.setValue(description, forKeyPath: "gameDesc")
                game.setValue(releaseDate, forKeyPath: "releaseDate")
                game.setValue(rating, forKeyPath: "gameRating")
                game.setValue(gameCount, forKeyPath: "gameCount")
                game.setValue(image.absoluteString, forKeyPath: "image")
                
                do {
                    try taskContext.save()
                    completion()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func deleteFavorite(id: Int, completion: @escaping () -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeCount
            
            if let batchDeleteResult = try? taskContext.execute(deleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }
}
