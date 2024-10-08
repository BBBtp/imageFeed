import UIKit
import Kingfisher


protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol! {get set}
    func configure(_ presenter: ImagesListPresenterProtocol)
    func updateTableViewAnimated()
}
final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    @IBOutlet private var tableView: UITableView!
    var presenter: ImagesListPresenterProtocol!
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var ImageListObserver: NSObjectProtocol?
    let currentDate = Date()
    
    func configure(_ presenter: ImagesListPresenterProtocol){
        self.presenter = presenter
        presenter.view = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        configure(presenter)
        ImageListObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ){ [weak self] _ in guard let self = self else {return}
            self.updateTableViewAnimated()
        }
        presenter.fetchPhotoNextPage()
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
            
            
            viewController.photo = presenter.photos[indexPath.row]
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource, ImagesListCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getPhotoCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        
        presenter.loadData(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}



extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if CommandLine.arguments.contains("-UITesting") {
                return
            }
        if indexPath.row == presenter.getPhotoCount() - 1 {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = presenter.getPhoto(for: indexPath)
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
        let oldCount = presenter.getPhotoCount()
        let newCount = ImagesListService.shared.photos.count
        
        presenter.photos = ImagesListService.shared.photos
        
        if oldCount != newCount{
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map {i in IndexPath(row: i, section: 0)}
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in}
        }
    }
}

extension ImagesListViewController{
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        
        let photo = presenter.getPhoto(for: indexPath)
        
        presenter.toggleLike(for: photo.id, isLiked: photo.isLiked) {
            [weak self] result in guard let self = self else {return}
            
            UIBlockingProgressHUD.show()
            switch result {
            case .success(_):
                UIBlockingProgressHUD.dismiss()
                
                presenter.photos = ImagesListService.shared.photos
                cell.setIsLiked(isLike: presenter.photos[indexPath.row].isLiked)
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                
                let AlertModel = AlertModel(title: "Упс..Что-то пошло не так", message: "Не удалось поставить лайк", firstButtonText: "Ок", secondButtonText: nil,completion: {}, secondCompletion: {})
                AlertPresenter.shared.show(vc: self, model: AlertModel)
            }
        }
    }
}


