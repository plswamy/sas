
package sas;

import java.security.Principal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.security.access.prepost.PreAuthorize;

@Controller
public class HelloWorldController {

  @RequestMapping("/helloworld")
  public ModelAndView hello(ModelMap model,Principal principal) {

    String loggedInUserName=principal.getName();

    return new ModelAndView("hello", "userName", loggedInUserName);
  }

  @PreAuthorize("hasRole('ROLE_ADMIN')")
  @RequestMapping("/admin")
  public ModelAndView helloAdmin(ModelMap model,Principal principal) {

    String loggedInUserName=principal.getName();

    return new ModelAndView("admin", "userName", loggedInUserName);
  }

  @RequestMapping("/normal-user")
  public ModelAndView helloNormalUser(ModelMap model,Principal principal) {

    String loggedInUserName=principal.getName();

    return new ModelAndView("normal_user", "userName", loggedInUserName);
  }

  @RequestMapping(value="/login", method = RequestMethod.GET)
  public String login(ModelMap model) {

    return "login";

  }

  @RequestMapping(value="/survey", method = RequestMethod.POST)
  public String survey(ModelMap model) {

    return "report";

  }

  @RequestMapping(value="/survey", method = RequestMethod.GET)
  public String surveyGet(ModelMap model) {

    return "survey";

  }

  @RequestMapping(value="/home", method = RequestMethod.POST)
  public String home(ModelMap model) {

    return "survey";

  }

  @RequestMapping(value="/home", method = RequestMethod.GET)
  public String homeGet(ModelMap model) {

    return "index";

  }

  @RequestMapping(value="/loginError", method = RequestMethod.GET)
  public String loginError(ModelMap model) {
    model.addAttribute("error", "true");
    return "login";
  }

  // for 403 access denied page
    @RequestMapping(value = "/403", method = RequestMethod.GET)
    public ModelAndView accesssDenied(Principal user) {

      ModelAndView model = new ModelAndView();
      if (user != null) {
        model.addObject("msg", "Hi " + user.getName()
        + ", You can not access this page!");
      } else {
        model.addObject("msg",
        "You can not access this page!");
      }

      model.setViewName("403");
      return model;
    }
}
