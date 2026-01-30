return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    
    require("luasnip.loaders.from_vscode").lazy_load()
    
    ls.add_snippets("java", {
      s("controller", {
        t({"@RestController", "@RequestMapping(\"/api/"}), i(1, "resource"), t({"\")", "public class "}), i(2, "Controller"), t({" {", "", "\t"}), i(0), t({"", "}"})
      }),
      
      s("getmapping", {
        t({"@GetMapping"}), i(1), t({"", "public ResponseEntity<"}), i(2, "Type"), t({"> "}), i(3, "methodName"), t({"() {", "\t"}), i(0), t({"", "}"})
      }),
      
      s("postmapping", {
        t({"@PostMapping"}), i(1), t({"", "public ResponseEntity<"}), i(2, "Type"), t({"> "}), i(3, "methodName"), t({"(@RequestBody "}), i(4, "Type"), t({" "}), i(5, "param"), t({") {", "\t"}), i(0), t({"", "}"})
      }),
      
      s("putmapping", {
        t({"@PutMapping(\"/{id}\")"}), t({"", "public ResponseEntity<"}), i(1, "Type"), t({"> "}), i(2, "methodName"), t({"(@PathVariable Long id, @RequestBody "}), i(3, "Type"), t({" "}), i(4, "param"), t({") {", "\t"}), i(0), t({"", "}"})
      }),
      
      s("deletemapping", {
        t({"@DeleteMapping(\"/{id}\")"}), t({"", "public ResponseEntity<Void> "}), i(1, "methodName"), t({"(@PathVariable Long id) {", "\t"}), i(0), t({"", "}"})
      }),
      
      s("service", {
        t({"@Service", "public class "}), i(1, "Service"), t({" {", "", "\t"}), i(0), t({"", "}"})
      }),
      
      s("repository", {
        t({"@Repository", "public interface "}), i(1, "Repository"), t({" extends JpaRepository<"}), i(2, "Entity"), t({", "}), i(3, "Long"), t({"> {", "\t"}), i(0), t({"", "}"})
      }),
      
      s("entity", {
        t({"@Entity", "@Table(name = \""}), i(1, "table_name"), t({"\")", "@Data", "@NoArgsConstructor", "@AllArgsConstructor", "public class "}), i(2, "Entity"), t({" {", "", "\t@Id", "\t@GeneratedValue(strategy = GenerationType.IDENTITY)", "\tprivate Long id;", "", "\t"}), i(0), t({"", "}"})
      }),
      
      s("autowired", {
        t({"@Autowired", "private "}), i(1, "Type"), t({" "}), i(2, "name"), t(";")
      }),
      
      s("lombok", {
        t({"@Data", "@NoArgsConstructor", "@AllArgsConstructor", "public class "}), i(1, "ClassName"), t({" {", "\t"}), i(0), t({"", "}"})
      }),
      
      s("config", {
        t({"@Configuration", "public class "}), i(1, "Config"), t({" {", "", "\t@Bean", "\tpublic "}), i(2, "Type"), t({" "}), i(3, "beanName"), t({"() {", "\t\t"}), i(0), t({"", "\t}", "}"})
      }),
      
      s("component", {
        t({"@Component", "public class "}), i(1, "Component"), t({" {", "", "\t"}), i(0), t({"", "}"})
      }),
      
      s("springbootapp", {
        t({"@SpringBootApplication", "public class "}), i(1, "Application"), t({" {", "", "\tpublic static void main(String[] args) {", "\t\tSpringApplication.run("}), f(function(args) return args[1][1] end, {1}), t({".class, args);", "\t}", "}"})
      }),
      
      s("test", {
        t({"@Test", "public void "}), i(1, "testMethod"), t({"() {", "\t"}), i(0), t({"", "}"})
      }),
      
      s("mockbean", {
        t({"@MockBean", "private "}), i(1, "Type"), t({" "}), i(2, "name"), t(";")
      }),
      
      s("transactional", {
        t({"@Transactional", "public "}), i(1, "void"), t({" "}), i(2, "methodName"), t({"() {", "\t"}), i(0), t({"", "}"})
      }),
    })
    
    vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump(1) end, {silent = true})
    vim.keymap.set({"i", "s"}, "<C-H>", function() ls.jump(-1) end, {silent = true})
  end,
}
