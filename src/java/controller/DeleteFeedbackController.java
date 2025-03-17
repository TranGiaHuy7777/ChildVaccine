package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import feedback.FeedbackDAO;
import customer.CustomerDTO;

@WebServlet("/DeleteFeedbackController")
public class DeleteFeedbackController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        CustomerDTO loggedInUser = (CustomerDTO) session.getAttribute("LOGIN_USER");

        if (loggedInUser == null) {
            response.sendRedirect("vaccinationSchedule.jsp");
            return;
        }

        try {
            int feedbackID = Integer.parseInt(request.getParameter("feedbackID"));
            String userID = loggedInUser.getUserID();

            FeedbackDAO feedbackDAO = new FeedbackDAO();
            boolean deleted = feedbackDAO.deleteFeedback(feedbackID, userID);

            if (deleted) {
                session.setAttribute("FEEDBACK_SUCCESS", "Feedback deleted successfully!");
            } else {
                session.setAttribute("FEEDBACK_ERROR", "Failed to delete feedback.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("FEEDBACK_ERROR", "An error occurred. Please try again.");
        }

        response.sendRedirect("FeedbackController");
    }
}
