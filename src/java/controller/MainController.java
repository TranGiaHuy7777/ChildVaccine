package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import customer.CustomerDAO;
import customer.CustomerDTO;
import javax.servlet.http.HttpSession;

@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {
    private static final String ERROR = "error.jsp";
    private static final String DEFAULT_PAGE = "vaccinationSchedule.jsp";
    private static final String LOGIN_PAGE = "login.jsp";
    private static final String LOGIN = "Login";
    private static final String LOGIN_CONTROLLER = "LoginController";
    private static final String LOGOUT = "Logout";
    private static final String LOGOUT_CONTROLLER = "LogoutController";
    private static final String SEARCH = "Search";
    private static final String SEARCH_CONTROLLER = "SearchController";
    private static final String DELETE = "Delete";
    private static final String DELETE_CONTROLLER = "DeleteController";
    private static final String UPDATE = "Update";
    private static final String UPDATE_CONTROLLER = "UpdateController";
    private static final String CREATE = "Create";
    private static final String CREATE_CONTROLLER = "CreateController";
    private static final String CENTER = "Center";
    private static final String CENTER_CONTROLLER = "CenterController";
    private static final String CUSTOMER = "Customer";
    private static final String CUSTOMER_CONTROLLER = "CustomerController";
    private static final String APPOINTMENT = "Appointment";
    private static final String APPOINTMENT_CONTROLLER = "AppointmentController";
    private static final String REPORT = "Report";
    private static final String REPORT_CONTROLLER = "ReportController";
    private static final String VACCINE = "Vaccine";
    private static final String VACCINE_CONTROLLER = "VaccinationController";
    private static final String SHOW_ADD_CHILD = "ShowAddChild";
    private static final String ADD_CHILD = "AddChild";
    private static final String VIEW_CHILDREN = "ViewChildren";
    private static final String BOOK_VACCINE = "BookVaccine";
    private static final String CHILD_CONTROLLER = "ChildController";
    private static final String CHILD_REGISTRATION = "childRegistration.jsp";
    private static final String SHOW_APPOINTMENT_FORM = "ShowAppointmentForm";
    private static final String BOOK_APPOINTMENT = "BookAppointment";
    private static final String SHOW_VACCINATION_SCHEDULE = "ShowVaccinationSchedule";
    private static final String VACCINATION_SCHEDULE_CONTROLLER = "VaccinationScheduleController";
    private static final String ADD_VACCINE = "AddVaccine";
    private static final String ADD_VACCINE_CONTROLLER = "AddVaccineController";
    private static final String UPDATE_VACCINATION_STATUS = "UpdateVaccinationStatus";
    private static final String UPDATE_VACCINATION_STATUS_CONTROLLER = "UpdateVaccinationStatusController";
    private static final String DOCTOR_LOGIN = "DoctorLogin";
    private static final String DOCTOR_LOGIN_CONTROLLER = "DoctorLoginController";


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String url = ERROR;
        HttpSession session = request.getSession();

        try {
            String action = request.getParameter("action");

            if (action == null) {
                url = DEFAULT_PAGE;
            } else {
                switch (action) {
                    case LOGIN:
                        url = LOGIN_CONTROLLER;
                        break;
                    case LOGOUT:
                        url = LOGOUT_CONTROLLER;
                        break;
                    case SEARCH:
                        url = SEARCH_CONTROLLER;
                        break;
                    case DELETE:
                        url = DELETE_CONTROLLER;
                        break;
                    case UPDATE:
                        url = UPDATE_CONTROLLER;
                        break;
                    case CREATE:
                        url = CREATE_CONTROLLER;
                        break;
                    case CENTER:
                        url = CENTER_CONTROLLER;
                        break;
                    case CUSTOMER:
                        url = CUSTOMER_CONTROLLER;
                        break;
                    case APPOINTMENT:
                        url = APPOINTMENT_CONTROLLER;
                        break;
                    case REPORT:
                        url = REPORT_CONTROLLER;
                        break;
                    case VACCINE:
                        url = VACCINE_CONTROLLER;
                        break;
                    case SHOW_APPOINTMENT_FORM:
                        url = "appointmentForm.jsp";
                        break;
                    case SHOW_ADD_CHILD:
                        url = CHILD_REGISTRATION;
                        break;
                    case ADD_CHILD:
                    case VIEW_CHILDREN:
                    case BOOK_VACCINE:
                        url = CHILD_CONTROLLER;
                        break;
                    case BOOK_APPOINTMENT:
                        url = APPOINTMENT_CONTROLLER;
                        break;
                    case SHOW_VACCINATION_SCHEDULE:
                        url = VACCINATION_SCHEDULE_CONTROLLER;
                        break;
                    case ADD_VACCINE:
                        url = ADD_VACCINE_CONTROLLER;
                        break;
                    case UPDATE_VACCINATION_STATUS:
                        url = UPDATE_VACCINATION_STATUS_CONTROLLER;
                        break;
                    case DOCTOR_LOGIN:
                        url = DOCTOR_LOGIN_CONTROLLER;
                        break;

                    default:
                        url = DEFAULT_PAGE;
                }
            }

            if (UPDATE.equals(action)) {
                String userID = request.getParameter("userID");
                String fullName = request.getParameter("fullName");
                String roleID = request.getParameter("roleID");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");

                CustomerDTO user = new CustomerDTO();
                user.setUserID(userID);
                user.setFullName(fullName);
                user.setRoleID(roleID);
                user.setEmail(email);
                user.setPhone(phone);

                CustomerDAO dao = new CustomerDAO();
                boolean checkUpdate = dao.update(user);
                System.out.println("Update result: " + checkUpdate);  // Debug line

                if (checkUpdate) {
                    url = "admin.jsp";
                    request.getSession().removeAttribute("LIST_USER");
                }
            }

        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
            e.printStackTrace();  // Add stack trace

        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
