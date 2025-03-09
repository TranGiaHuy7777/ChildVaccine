package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import feedback.FeedbackDAO;
import feedback.FeedbackDTO;
import customer.CustomerDTO;

@WebServlet("/FeedbackController")
public class FeedbackController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        CustomerDTO loggedInUser = (CustomerDTO) session.getAttribute("LOGIN_USER");

        if (loggedInUser == null) {
            response.sendRedirect("vaccinationSchedule.jsp");
            return;
        }

        String userID = loggedInUser.getUserID();
        FeedbackDAO feedbackDAO = new FeedbackDAO();

        try {
            List<FeedbackDTO> userFeedback = feedbackDAO.getFeedbackByUserId(userID);
            request.setAttribute("userFeedback", userFeedback);
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        CustomerDTO loggedInUser = (CustomerDTO) session.getAttribute("LOGIN_USER");

        if (loggedInUser == null) {
            response.sendRedirect("vaccinationSchedule.jsp");
            return;
        }

        try {
            String userID = loggedInUser.getUserID();
            int centerID = Integer.parseInt(request.getParameter("centerID"));
            String feedbackText = request.getParameter("feedbackText");
            int rating = Integer.parseInt(request.getParameter("rating"));
            LocalDate feedbackDate = LocalDate.now();

            if (feedbackText != null && !feedbackText.trim().isEmpty() && rating >= 1 && rating <= 5) {
                FeedbackDTO feedback = new FeedbackDTO(0, userID, centerID, feedbackText, rating, feedbackDate);
                FeedbackDAO feedbackDAO = new FeedbackDAO();
                boolean success = feedbackDAO.saveFeedback(feedback);

                if (success) {
                    session.setAttribute("FEEDBACK_SUCCESS", "Thank you for your feedback!");
                } else {
                    session.setAttribute("FEEDBACK_ERROR", "Failed to submit feedback. Please try again.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("FEEDBACK_ERROR", "An error occurred. Please try again.");
        }

        response.sendRedirect("FeedbackController");
    }
}
