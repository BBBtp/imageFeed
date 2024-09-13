
import UIKit
import Kingfisher
final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!

    @IBAction func likeButtonClicked(_ sender: Any?) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    override func prepareForReuse() {
            super.prepareForReuse()
            cellImage.kf.cancelDownloadTask()
            cellImage.image = nil
        }
    
    func setIsLiked (isLike: Bool) {
        let likedImage = isLike ? UIImage(named:"Active") : UIImage(named:"No Active")
        self.likeButton.setImage(likedImage, for: .normal)
    }
}
