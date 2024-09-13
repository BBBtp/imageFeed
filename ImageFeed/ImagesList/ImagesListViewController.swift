import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    private var ImageListObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    
    let currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        ImageListObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ){ [weak self] _ in guard let self = self else {return}
            self.updateTableViewAnimated()
        }
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            
            viewController.photo = photos[indexPath.row]
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell,with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let photoUrl = URL(string: photo.regularImgUrl)
        cell.dateLabel.isHidden = true
        cell.likeButton.isHidden = true
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: photoUrl,
                                   placeholder: UIImage(named: "load"),
                                   options: [
                                    .cacheSerializer(FormatIndicatedCacheSerializer.png),
                                    .transition(.fade(0.2))
                                   ]
        )
        {
            result in
            switch result{
            case .success(let value):
                print("Image: \(value.image)")
                print("Cache type: \(value.cacheType)")
                print("Sourse: \(value.source)")
                
                
                cell.dateLabel.isHidden = false
                cell.likeButton.isHidden = false
                
                
                cell.dateLabel.text = photo.createdAt != nil ? (self.dateFormatter.string(from: photo.createdAt ?? Date())) : ""
                let likedImage = photo.isLiked ? UIImage(named:"Active") : UIImage(named:"No Active")
                cell.likeButton.setImage(likedImage, for: .normal)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
        
    }
}

extension ImagesListViewController {
    func updateTableViewAnimated(){
        let oldCount = photos.count
        let newCount = ImagesListService.shared.photos.count
        
        photos = ImagesListService.shared.photos
        
        if oldCount != newCount{
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map {i in IndexPath(row: i, section: 0)}
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in}
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        
        let photo = photos[indexPath.row]
        
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: photo.isLiked) {
            [weak self] result in guard let self = self else {return}
            
            UIBlockingProgressHUD.show()
            switch result {
            case .success(_):
                UIBlockingProgressHUD.dismiss()
                
                self.photos = ImagesListService.shared.photos
                cell.setIsLiked(isLike: self.photos[indexPath.row].isLiked)
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                
                let alert = UIAlertController(title: "Упс..Что-то пошло не так", message: "Не удалось поставить лайк", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ок", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
}


