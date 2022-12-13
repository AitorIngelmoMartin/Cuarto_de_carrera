import cv2
import numpy as np

# Create a named window for the display.
win_name = 'Destination Image'


# ------------------------------------------------------------------------------
# Define mouse callback function.
# ------------------------------------------------------------------------------
def mouse_handler(event, x, y, flags, data):
    if event == cv2.EVENT_LBUTTONDOWN:
        # Render points as yellow circles in destination image.
        cv2.circle(data['img'], (x, y), radius=5, color=(0, 255, 255), thickness=-1, lineType=cv2.LINE_AA)
        cv2.imshow(win_name, data['img'])
        if len(data['points']) < 4:
            data['points'].append([x, y])


# ------------------------------------------------------------------------------
# Define convenience function for retrieving ROI points in destination image.
# ------------------------------------------------------------------------------
def get_roi_points(img):
    # Set up data to send to mouse handler.
    data = {'img': img.copy(), 'points': []}
    # Set the callback function for any mouse event.
    cv2.imshow(win_name, img)
    cv2.setMouseCallback(win_name, mouse_handler, data)
    cv2.waitKey(0)

    # Convert the list of four separate 2D ROI coordinates to an array.
    roi_points = np.vstack(data['points']).astype(float)
    # Close the window.
    cv2.destroyAllWindows()
    return roi_points

